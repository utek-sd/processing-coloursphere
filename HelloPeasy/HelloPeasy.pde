/*
  
  Use this sketch in conjunction with the Arduino_COLOUR skecth uploaded to your Arduino UNO board. For sensor wiring see this page --> https://learn.adafruit.com/adafruit-color-sensors/arduino-code
  
*/


import peasy.*;
import processing.serial.*;

//make sure to install the Peasy cam library via Sketch >> Import Library >> Add Library and then search for Peasycam
PeasyCam camera;

public void settings() {
  size(800, 600, P3D);
}

Serial port;
CameraState state;

PVector p1= new PVector (); 
PVector p2= new PVector (); 

int DEFAULT_LENGTH = 500;
int scale = 400;
String buff = "";
int wRed, wGreen, wBlue, wClear;
String hexColor = "ffffff";


public void setup() {
  camera = new PeasyCam(this, 800);
  //camera.setYawRotationMode();   // like spinning a globe
  //camera.setPitchRotationMode(); // like a somersault  
  //camera.setSuppressRollRotationMode(); 
  camera.setMinimumDistance(400);
  state = camera.getState();
  // remember to replace COM20 with the appropriate serial port on your computer ex Serial.list()[1]
  port = new Serial(this, "COM4", 9600); 
  port.clear();
  hint(ENABLE_DEPTH_TEST);
  hint(ENABLE_DEPTH_SORT);
}

public void draw() {    

  lights();    
  background(wRed, wGreen, wBlue);  
  drawAxes();  
  readSerial();
  drawPoints();
}

void readSerial() {  
  while (port.available() > 0) {
    serialEvent(port.read());
  }
}

//97 103 47
//105 99 43

void drawPoints() {

  stroke(255, 255, 255);
  line(0, 0, 0, scale * wRed, scale *  wGreen, scale *wBlue);   
  pushMatrix();  
  translate(wRed, wGreen, wBlue);
  fill(128, 128, 128);
  sphere(10);  
  popMatrix();

  line(wRed, wGreen, 0, wRed, wGreen, wBlue);  
  line(wRed, 0, 0, wRed, wGreen, 0);  
  line(0, wGreen, 0, wRed, wGreen, 0);
}

public void drawAxes() {

  strokeWeight(0);
  stroke(255);
  fill(128, 0, 0, 128);
  sphere(255);

  strokeWeight(3);
  stroke(255, 0, 0); //blue is x
  line(0, 0, 0, DEFAULT_LENGTH, 0, 0); 

  stroke(0, 255, 0); //red is y
  line(0, 0, 0, 0, DEFAULT_LENGTH, 0); 

  stroke(0, 0, 255); //green is z
  line(0, 0, 0, 0, 0, DEFAULT_LENGTH);
}

public void keyReleased() {
  if (key == '1') state = camera.getState();
  if (key == '2') camera.setState(state, 1000);
}


void serialEvent(int serial) {
  if (serial != '\n') {
    buff += char(serial);
  } else {
    int cRed = buff.indexOf("R");
    int cGreen = buff.indexOf("G");
    int cBlue = buff.indexOf("B");
    //int clear = buff.indexOf("C");

    //if(clear >=0){
    //  String val = buff.substring(clear+3);
    //  val = val.split("\t")[0];
    //  wClear = Integer.parseInt(val.trim());
    //} else { return; }

    try {

      if (cRed >=0) {
        String val = buff.substring(cRed+3);
        val = val.split("\t")[0]; 
        wRed = Integer.parseInt(val.trim());
      } else { 
        return;
      }

      if (cGreen >=0) {
        String val = buff.substring(cGreen+3);
        val = val.split("\t")[0]; 
        wGreen = Integer.parseInt(val.trim());
      } else { 
        return;
      }

      if (cBlue >=0) {
        String val = buff.substring(cBlue+3);
        val = val.split("\t")[0]; 
        wBlue = Integer.parseInt(val.trim());
      } else { 
        return;
      }
    }
    catch(Exception x) {
      port.clear();
    }
    //wRed *= 255; wRed /= wClear;
    //wGreen *= 255; wGreen /= wClear; 
    //wBlue *= 255; wBlue /= wClear; 

    print("Red: "); 
    print(wRed);
    print("\tGrn: "); 
    print(wGreen);
    print("\tBlue: "); 
    print(wBlue);

    print("Mag: ");
    print(sqrt(wRed*wRed + wBlue*wBlue + wGreen*wGreen));
    println();

    buff = "";
  }
}
