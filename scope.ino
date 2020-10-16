void setup() {
  // put your setup code here, to run once:
  Serial.begin(57600);
  pinMode(A0, INPUT);

}
bool send = false;

void loop() {
  // put your main code here, to run repeatedly:
  if (send) {
    Serial.write(analogRead(A0) >> 2);
  }
  
  if (Serial.available() > 0) {
    byte inbyte = Serial.read();
    if (inbyte == 48)
      send = false;
    else if (inbyte == 49)
      send = true;
  }
}
