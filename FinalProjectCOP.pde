import java.io.*;
import java.util.*;
import javafx.util.*;
import controlP5.*;
import queasycam.*;
import javax.swing.*;

QueasyCam cam;
Data data;

ControlP5 controls;
Textfield tf;
Slider s;

String searchCon;
boolean search = false;
float renderDist = 0;
ArrayList<PVector> dots;

void setup() {
  size(1200, 800, P3D);
  perspective(radians(60.0f), width/(float)height, 0.1, 1000);
  controls = new ControlP5(this);

  cam = new QueasyCam(this);
  cam.speed = 0;
  cam.sensitivity = 0;
  cam.position = new PVector(0, 0, 0);
  //camera.CameraSetup();

PFont font = createFont("Arial Bold",15);
  tf = controls.addTextfield("CONSTELLATIONS HERE")
    .setPosition(20, 20)
    .setSize(220, 30)
    //.setText("CONSTELLATIONS HERE")
    .setFont(font)
    .setAutoClear(false)
    ;


  s = controls.addSlider("RENDER DISTANCE")
    .setPosition(260, 20)
    .setSize(220, 30)
    .setRange(1, 119613)
    .setValue(50000)
    .setFont(font)
    .setSliderMode(Slider.FLEXIBLE)
    ;

  dots = new ArrayList<PVector>();

  //setUp dots
  stroke(255);
  strokeWeight(20);
  for (int i = 0; i < 10000; i++) {
    float x = random(-500, 500);
    float y = random(-500, 500);
    float z = random(-500, 500);
    dots.add(new PVector(x, y, z));
  }

  data = new Data();
  data.loadData();
  data.loadConData();
  //data.constInfo();
}

void draw()
{
  lights();
  background(0);
  perspective(radians(60.0f), width/(float)height, 0.1, 1000);
  //118141 and 118330 off tilt the graph

  renderDist = 119613 - s.getValue();
  colorMode(RGB, 255, 255, 255);
  stroke(255);
  strokeWeight(1);
  for (int i = 0; i < data.starDist.size() - renderDist; i++) {
    float x = (float)data.starData.get(data.starDist.get(i).getValue()).x;
    float y = (float)data.starData.get(data.starDist.get(i).getValue()).y;
    float z = (float)data.starData.get(data.starDist.get(i).getValue()).z;
    float alpha = (float)data.starData.get(data.starDist.get(i).getValue()).ra;
    float delta = (float)data.starData.get(data.starDist.get(i).getValue()).dec;

    float dist = (float)data.starData.get(data.starDist.get(i).getValue()).dist;
    delta = delta * (PI / 180);
    alpha = alpha * 15 * PI / 180;
    float catX = cos(alpha) * cos(delta) * dist;
    float catY = sin(alpha) * cos(delta) * dist;
    float catZ = sin(delta) * dist;
    point(catX, catY, catZ);
    
  }

  if (search == true) {
    DrawConstellation(searchCon);
  }

  camera();
  perspective();
}

void DrawConstellation(String con) {

  //if con is in map
  try{
  for (Map.Entry<Integer, ArrayList<Integer>> valEntry : data.constellations.get(con).adjList.entrySet()) {
    StarInfo edge = new StarInfo();
    edge = data.starData.get(valEntry.getKey());

    float ex = (float)edge.x;
    float ey = (float)edge.y;
    float ez = (float)edge.z;
    float epha = (float)edge.ra;
    float eta = (float)edge.dec;

    epha = epha * 15 * PI / 180;
    eta = eta * (PI / 180);
    float eR = (float)edge.dist;
    float eCatX = cos(epha) * cos(eta) * eR;
    float eCatY = sin(epha) * cos(eta) * eR;
    float eCatZ = sin(eta) * eR;

    for (int i = 0; i < valEntry.getValue().size(); i++) {
      StarInfo pointee = new StarInfo();
      pointee = data.starData.get(valEntry.getValue().get(i));

      float x = (float)pointee.x;
      float y = (float)pointee.y;
      float z = (float)pointee.z;
      float alpha = (float)pointee.ra;
      float delta = (float)pointee.dec;

      alpha = alpha * 15 * PI / 180;
      delta = delta * (PI / 180);
      float R = (float)pointee.dist;
      float catX = cos(alpha) * cos(delta) * R;
      float catY = sin(alpha) * cos(delta) * R;
      float catZ = sin(delta) * R;
      
      
      colorMode(HSB, 360,100,100);
      stroke(183,100,100);
      
      strokeWeight(9);
      point(catX, catY, catZ);
      point(eCatX, eCatY, eCatZ);
      strokeWeight(2);
      line(eCatX, eCatY, eCatZ, catX, catY, catZ);
    }
  }
  }
  catch(NullPointerException e){
    println("Re-enter Constellation");
    search = false;
  }
}

void mousePressed()
{
  if (mouseButton == LEFT && !controls.isMouseOver())
  {
    // Enable the camera
    cam.sensitivity = 1.0f;
  }
}
void mouseReleased()
{  
  if (mouseButton == LEFT)
  {
    // "Disable" the camera by setting move and turn speed to 0
    cam.sensitivity = 0;
  }
}
void keyPressed() 
{
  if (key == ENTER) {
      searchCon = tf.getText();
      search = true;
  }
}
