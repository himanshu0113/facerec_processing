import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture mycapture;
OpenCV opencv;

int x = 0;
Boolean cap = false;
PImage cropped;
int pic_count = 40;
String path;

void setup() {
  size(640, 480);
  mycapture = new Capture(this, 640, 480); 
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  path = "data/new-"+day()+"-"+hour()+"-"+minute()+"/";

  frameRate(1);
  mycapture.start();
}

void draw() {
  image(mycapture, 0, 0);

  //mycapture.save("qdqfffwe-###.jpg");
  if (cap && x < pic_count ) {
    opencv.loadImage(mycapture);
    Rectangle[] faces = opencv.detect(); //<>//
    if (faces.length > 0) { //<>//
      
      //cropped = mycapture.get(faces[0].x,faces[0].y,faces[0].width, faces[0].height); //<>//
      
      //cropped.resize(640,480);
      //image(cropped, 0, 0 );
      //mycapture.get(faces[0].x,faces[0].y,faces[0].width, faces[0].height);
      
      //cropped.save(path +"img-0"+x+".jpg");
      
      // Saves each frame as line-000001.png, line-000002.png, etc.
      saveFrame(path +"img-####.jpg");
      x = x + 1;
      faces =null;
    }
    
  } else if(x >= pic_count){
    mycapture.stop();
    println("Capture Complete.");
    noLoop();
  }

}

void captureEvent(Capture mycapture) {
  mycapture.read();
}

void keyPressed() {
  println("Key Pressed.");
  cap = !cap;
}