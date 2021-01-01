//Make sure to install the Adafruit TCS34725 library. Sketch >> Include Library >> Manage Libraries Library and then search for "Adafruit TCS34725"
//If you are having trouble see https://learn.adafruit.com/adafruit-color-sensors/arduino-code to learn how install this library.

#include <Adafruit_TCS34725.h>
Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_700MS, TCS34725_GAIN_1X);

void setup() {

  Serial.begin(9600);  
  if (tcs.begin()) {
    //    Serial.println("Found sensor");
  } else {
    Serial.println("No TCS34725 found ... check your connections");
    while (1);
  }

  pinMode(12, INPUT);

}

void convert_to_rgb(int* red, int* green, int* blue, int* c) {  
  
  uint16_t r = *red, g = *green, b = *blue;
  uint32_t sum = *c;

  // Avoid divide by zero errors ... if clear = 0 return black
  if (sum == 0) {
    *red = *green = *blue = 0;
    return;
  }

  r = (float)r / sum * 255.0;
  g = (float)g / sum * 255.0;
  b = (float)b / sum * 255.0;

  *red = r;
  *blue = b;
  *green = g;

}

void test_colour() {

  //to turn the lights on and off, connect the interrupt pin directly to the LED pin. Otherwise you will not be able to turn the light on or off.
  if (digitalRead(12) == LOW) {
    tcs.setInterrupt(true);  // turn off LED when true}
  }
  else {
    tcs.setInterrupt(false);  // turn off LED when true}
  }

  int r, g, b, c;
  tcs.getRawData(&r, &g, &b, &c);
  convert_to_rgb(&r, &g, &b, &c);
  Serial.print("R:\t"); Serial.print(int(r));
  Serial.print("\tG:\t"); Serial.print(int(g));
  Serial.print("\tB:\t"); Serial.print(int(b));
  Serial.print("\n");

}


void loop(){

  test_colour();
  
}
