void setup() {
  // put your setup code here, to run once:
  Serial.begin(57600);
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
}
bool send = false;

void loop() {
  if (send) {
    Serial.write(analogRead(A0)>>2);
    Serial.write(analogRead(A1)>>2);
  }
  
  if (Serial.available() > 0) {
    byte inbyte = Serial.read();
    if (inbyte == 48)
      send = false;
    else if (inbyte == 49)
      send = true;
  }
}
