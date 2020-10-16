import processing.serial.*;

double scales[]={1/4, 1/2, 1, 2, 4, 8, 16, 32, 64};
int scale=3;
Serial myPort;
boolean readSerial;
int buffsize=64000;
char[] buffer = new char[buffsize];
int head=0;
int charstart=0;

void setup() {
  size(800, 600);
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 57600);
}

void draw() {
  background(0);
  stroke(0, 150, 0);
  fill(0);
  //rect(50,50,700,500);
  for (int i=0; i<15; i++) {
    line(50+i*50, 50, 50+i*50, 550);
  }
  for (int i=0; i<11; i++) {
    line(50, 50+i*50, 750, 50+i*50);
  }
  stroke(0, 255, 0);
  charstart=head-1;
  for (int i=0; i<700; i++) {
    line(50+i, 550-buffer[(buffsize+charstart-(int)Math.round(i*scales[scale]))%buffsize]*2, 51+i, 550-buffer[((buffsize+charstart-(int)Math.round((i+1)*scales[scale]))%buffsize)]*2);
  }
}

void serialEvent(Serial x) {
  buffer[head++]=myPort.readChar();
  head=head%buffsize;
}

void keyPressed() {
  if (keyCode==10) {
    myPort.write(49);
  } else if (keyCode==32) {
    myPort.write(48);
  } else if (keyCode==UP && scale>0) {
    scale--;
  } else if (keyCode==DOWN && scale<8) {
    scale++;
  }
}
