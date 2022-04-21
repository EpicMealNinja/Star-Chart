import java.io.*;
import java.util.*;
import javafx.util.*;
import controlP5.*;
import queasycam.*;
import javax.swing.*;

QueasyCam cam;        //Library with camera functionality
Data data;            //Instance of Data Class

ControlP5 controls;    //Library with UI functionality
Textfield tf;          //Objects in the ControlP5 library
Slider s;

String searchCon;          //The Constellation searched
boolean search = false;    //are we searching actively, used for the textfield
float renderDist = 0;      //the number of stars to be outputted by distance. It is in association with the map/graph    

void setup() {
  size(1200, 800, P3D);                                              //sets size of the screen
  perspective(radians(60.0f), width/(float)height, 0.1, 1000);       //sets the perspective. Just needed to have for camera functionality
  controls = new ControlP5(this);                                    //Initialize controls instance of the ControlP5 library

  cam = new QueasyCam(this);                                         //same as above but for the camer
  cam.speed = 0;                                                     //default values for camera location, movement, and sensitivity
  cam.sensitivity = 0;                                               //they are initialized to 0 so camera is only moved when left-clicked
  cam.position = new PVector(0, 0, 0);

  PFont font = createFont("Arial Bold", 15);                          //Used in both controls objects
  tf = controls.addTextfield("CONSTELLATIONS HERE")                   //We make all the settings for the textfield object. It is what we type into
    .setPosition(20, 20)
    .setSize(220, 30)
    //.setText("CONSTELLATIONS HERE")
    .setFont(font)
    .setAutoClear(false)
    ;


  s = controls.addSlider("RENDER DISTANCE")
    .setPosition(260, 20)
    .setSize(220, 30)
    .setRange(1, 119613)                                                //Maximum number of stars in the database
    .setValue(50000)
    .setFont(font)
    .setSliderMode(Slider.FLEXIBLE)                                    //Used so it doesnt jump forward/back and look clunky
    ;

  data = new Data();                                                  //data instance calling functions from Data class
  data.loadData();                                                    //Loads data from database
  data.loadConData();                                                 //Loads data from our self-made database. This took so long and went through multiple iterations
}

void draw()
{
  background(0);                                                      //Everything is redrawn every frame. So we reset the background to black then draw the rest
  perspective(radians(60.0f), width/(float)height, 0.1, 1000);        //has to be recalled every frame

  renderDist = 119613 - s.getValue();                                 //max stars - the value of our slider
  colorMode(RGB, 255, 255, 255);
  stroke(255);
  strokeWeight(1);
  for (int i = 0; i < data.starDist.size() - renderDist; i++) {                        //goes through the ArrayList - the render distance
    float alpha = (float)data.starData.get(data.starDist.get(i).getValue()).ra;          //The stars are initially recorded in Equitorial Cartesian Coordinates
    float delta = (float)data.starData.get(data.starDist.get(i).getValue()).dec;          //all our stars have a bunch of values used to calculate its proper location.
    float dist = (float)data.starData.get(data.starDist.get(i).getValue()).dist;

    delta = delta * (PI / 180);
    alpha = alpha * 15 * PI / 180;                                                      //transfered to degrees, then radians, then to degrees that are readable to us

    float catX = cos(alpha) * cos(delta) * dist;                                      
    float catY = sin(alpha) * cos(delta) * dist;
    float catZ = sin(delta) * dist;
    point(catX, catY, catZ);
  }

  if (search == true) {
    DrawConstellation(searchCon);      //Only draws the constellation if you are searching for it in the textbox
  }

  camera();                            //recalled after drawing objects so you can see them
  perspective();
}

void DrawConstellation(String con) {

  //if con is in map
  try {
    for (Map.Entry<Integer, ArrayList<Integer>> valEntry : data.constellations.get(con).adjList.entrySet()) {     //iterates through the map adj stars to the con star
      StarInfo edge = new StarInfo();                         
      edge = data.starData.get(valEntry.getKey());              

      float epha = (float)edge.ra;                      //a slightly different version of the equation in draw
      float eta = (float)edge.dec;
      float eR = (float)edge.dist;

      epha = epha * 15 * PI / 180;
      eta = eta * (PI / 180);

      float eCatX = cos(epha) * cos(eta) * eR;
      float eCatY = sin(epha) * cos(eta) * eR;
      float eCatZ = sin(eta) * eR;

      for (int i = 0; i < valEntry.getValue().size(); i++) {
        StarInfo pointee = new StarInfo();
        pointee = data.starData.get(valEntry.getValue().get(i));
        float alpha = (float)pointee.ra;
        float delta = (float)pointee.dec;
        float R = (float)pointee.dist;

        alpha = alpha * 15 * PI / 180;
        delta = delta * (PI / 180);

        float catX = cos(alpha) * cos(delta) * R;
        float catY = sin(alpha) * cos(delta) * R;
        float catZ = sin(delta) * R;


        colorMode(HSB, 360, 100, 100);                //Changes the mode of color from RGB to HSB
        stroke(183, 100, 100);

        strokeWeight(9);          
        point(catX, catY, catZ);                          //Draws a point representing a star at the given location
        point(eCatX, eCatY, eCatZ);
        strokeWeight(2);
        line(eCatX, eCatY, eCatZ, catX, catY, catZ);      //Draws a line from the points provided
      }
    }
  }
  catch(NullPointerException e) {            //outputs if you mispell or dont captilize a constilation
    println("Re-enter Constellation");
    search = false;                          //keeps from reoutputting over and over
  }
}

void mousePressed()
{
  if (mouseButton == LEFT && !controls.isMouseOver())      //if mouse is pressed and you are NOT hovering over the slider/text
  {
    // Enable the camera
    cam.sensitivity = 1.0f;                                //basic sensitivity to turn
  }
}
void mouseReleased()
{  
  if (mouseButton == LEFT)                                     
  {
    cam.sensitivity = 0;                                  // "Disable" the camera by setting move and turn speed to 0
  }
}
void keyPressed() 
{
  if (key == ENTER) {
    searchCon = tf.getText();                             //gets the text from the textbox  
    search = true;
  }
}
