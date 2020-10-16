import processing.serial.*;

double scales[]={1, 2, 4, 8, 15, 25, 50, 125, 250, 500};
int scale=3;
Serial myPort;
boolean readSerial;
int buffsize=500000;
char[] buffer = new char[buffsize];
int head=0;
int charstart=0;
int y1sum, y2sum;
boolean running=false;
int viewOffset=0;
boolean maxmode=false;

void setup() {
  size(800, 600);
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 57600);
}

void draw() {
  background(0);
  stroke(0, 150, 0);
  fill(0, 255, 0);
  for (int i=0; i<15; i++) {
    line(50+i*50, 40, 50+i*50, 550);
  }
  textSize(13);
  for (int i=0; i<11; i++) {
    line(50, 550-i*51, 750, 550-i*51);
    text((5-i*0.5)+"V", 20, 50*(i+1));
    text((5-i*0.5)+"V", 755, 50*(i+1));
  }
  stroke(0, 255, 0);
  charstart=head-2;
  for (int i=1; i<700; i++) {
    y1sum=y2sum=0;
    int y1=0;
    int y2=0;
    if (!maxmode) {
      for (int x=0; x<scales[scale]; x++) {
        y1sum+=buffer[(buffsize+charstart-(int)Math.round((i+viewOffset)*scales[scale])+x)%buffsize];
        y2sum+=buffer[((buffsize+charstart-(int)Math.round((i+1+viewOffset)*scales[scale])+x)%buffsize)];
      }
      y1=(int)(y1sum/scales[scale]);
      y2=(int)(y2sum/scales[scale]);
    } else{
      for (int x=0; x<scales[scale]; x++) {
        y1=max(y1, buffer[(buffsize+charstart-(int)Math.round((i+viewOffset)*scales[scale])+x)%buffsize]);
        y2=max(y2, buffer[((buffsize+charstart-(int)Math.round((i+1+viewOffset)*scales[scale])+x)%buffsize)]);
      }
    }
    line(750-i, Math.round(550-y2*2), 751-i, Math.round(550-y1*2));
    textSize(16);
    text("timebase: "+scales[scale]*8+"ms", 50, 570);
    text("Status: "+(running ? "LIVE" : "Stoped"), 250, 570);
    text("Mode: "+(maxmode?"MAX":"AVG"), 450, 570);
  }
}

void serialEvent(Serial x) {
  buffer[head++]=myPort.readChar();
  head=head%buffsize;
}

void keyPressed() {
  if (keyCode==32) {
    running=!running;
    myPort.write(48+(running?1:0));
    if (running) viewOffset=0;
  } else if (keyCode==UP && scale>0) {
    scale--;
    viewOffset<<=1;
  } else if (keyCode==DOWN && scale<9) {
    scale++;
    viewOffset>>=1;
  } else if (keyCode==LEFT && !running) {
    viewOffset++;
  } else if (keyCode==RIGHT && !running) {
    if (viewOffset>0) viewOffset--;
  } else if (keyCode==10) {
    maxmode=!maxmode;
  }
}
