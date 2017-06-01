import cern.colt.*;
import peigenface.*;
import processing.video.*;
import java.lang.reflect.Field;
import gab.opencv.*;
import java.awt.*;

PEigenface face;
Capture testCapture;
OpenCV opencv;

int imgW = 180;
int imgH = 200;

String[] testFilenames;
String[] trainingFilenames;

PImage[] trainingImages;
PImage[] eigenfaces;

PImage matchingImage;
String matchingImageFilename;
PImage testImage;
String testImageFilename;

int mostInfluentialEigenface;
PImage currentEigenface;
double maxWeight;

Boolean matchFound = false;
double avg_weight = 0;

void run_recognizer() {
    // load all the sample face images for training
  java.io.File trainingFolder = new java.io.File(dataPath("samples/"));
  trainingFilenames = trainingFolder.list();
  trainingImages = new PImage[trainingFilenames.length];
  
  testCapture = new Capture(this, 640,480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  for (int i = 0; i < trainingFilenames.length; i++) {
    println("samples/" + trainingFilenames[i]);
    trainingImages[i] = loadImage("samples/" + trainingFilenames[i]);
  }

  println(trainingImages.length + " training Images"); 

  // initialize our eigenface recognizer with the training images
  face = new PEigenface(this);
  face.initEigenfaces(trainingImages);

  // get our actual eigenface images
  // (these are the visual representation of what
  // is unique about each face relative to the others.)
  eigenfaces = getEigenfaces();

  // load up our test images
  java.io.File folder = new java.io.File(dataPath("tests"));
  testFilenames = folder.list();
  
  //// test a new image
  //testNewImage();
}

//Draw all matches and eigenfaces
void draw_eigenfaces() {
  currentEigenface.resize(0,imgH);
  image(currentEigenface, 0, 0);
  text("maxWeight:\n " + maxWeight, 0, imgH-25);

  testImage.resize(imgW,0);
  image(testImage, imgW, 0);
  text("TEST:\n" + testImageFilename, imgW, imgH - 25);
  //text("TEST:\n", imgW, imgH - 25);
  
  matchingImage.resize(imgW,0);
  image(matchingImage, imgW * 2, 0);
  text("MATCH:\n" + matchingImageFilename, imgW * 2, imgH - 25);
  
  drawAllEigenfaces();
}

// draw the eigenfaces in a grid
// with a red rectangle around the
// one that makes up the principle component
// for the current test image
void drawAllEigenfaces() {
  int i = 0;
  int col = 0;
  int row = 0;
  while (i < eigenfaces.length) {
    image(eigenfaces[i], col*54, imgH + row*54, 54, 54);    

    if (i == mostInfluentialEigenface) {
      stroke(255, 0, 0);
      noFill();
      rect(col*54, imgH + row*54, 54, 54);
    }

    i++;
    col++;
    if (col > 9) {
      col = 0;
      row++;
    }
  }
}

void testNewImage() {
   //load a random image from the test folder
  //int testImageNum = int(random(0, testFilenames.length-1));
  //testImage = loadImage("tests/" + testFilenames[testImageNum]);
  //testImageFilename = testFilenames[testImageNum];
  
  //Take image from cam
  //capture image for testing
  testCapture.start();
  
  println("You are being captured.");
  delay(3000);
  Rectangle[] faces;
  
  while(true) {
    println("In");
    image(testCapture, 0, 0);
    opencv.loadImage(testCapture);
    faces = opencv.detect();
    if(faces.length > 0) break;
    println("In");
  }
  println("Out");
  
  testImageFilename = "Test"+minute();
  
  //load test image 
  testImage = testCapture.get(faces[0].x-10,faces[0].y-10,faces[0].width+10, faces[0].height+10);
  testCapture.stop();
  
  // find the matching image for our test image from the training images
  int resultImageNum = face.findMatchResult(testImage, trainingImages.length);
  matchingImage = trainingImages[resultImageNum];
  matchingImageFilename = trainingFilenames[resultImageNum];

  // measure the weights: how much did each eigenface
  // contribute to the current test image
  double[] weights = face.getWeights(face.getBrightnessArray(testImage), trainingImages.length);   

  // find the index of the one that contributed the most
  // (i.e. with the max weight)
   maxWeight = -10000;
   avg_weight = 0;
  for(int i = 0; i < weights.length; i++){
    if(weights[i] > maxWeight){
      mostInfluentialEigenface = i;
      maxWeight = weights[i];
    }
    print(""+weights[i]+"\t");
    avg_weight += (weights.length - i)*weights[i];
  }
  avg_weight = avg_weight/weights.length;
  println("Avg weight = " + (avg_weight));
  println("");
  currentEigenface = eigenfaces[mostInfluentialEigenface];
  
  //check for match
  if(avg_weight < 0 && avg_weight >= -4000) {
    matchFound = true;
  }
  if(matchFound) {
    println("Matched!!");
  }
  else {
    println("Not Matched!!");
  }
}

//void keyPressed() {
//  matchFound = false;
//  testNewImage();
//}

// This funciton gets the array of eigenface images 
// out of PEigenface. It is ugly because it uses some java
// magic to extract a non-public variable.
PImage[] getEigenfaces() {
  PImage[] result = new PImage[trainingImages.length];
  try {
    Class c = face.getClass();
    Field field = c.getDeclaredField("imagesEigen");
    field.setAccessible(true);
    result = (PImage[])field.get(face);
  } 
  catch(Exception e) {
    println(e.toString());
  }
  return result;
}

void captureEvent(Capture c) {
  c.read();
}