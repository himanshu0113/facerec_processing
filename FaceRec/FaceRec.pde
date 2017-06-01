import controlP5.*;
import drop.*;
import java.io.*;

ControlP5 cp5;
SDrop drop;
MyDropListener m;

float unit, theta;
int num = 25, frames=180;
Boolean flag = false, locked = false;
int options =0;

controlP5.Button b, unlock, lock;
Textlabel label1, label2;

void setup() {
  size(640, 480, P3D);
  cp5 = new ControlP5(this);
  drop = new SDrop(this);
  m = new MyDropListener();
  drop.addDropListener(m);
  b = cp5.addButton("identify",1,width/4, height-40,width/2, 30)
     .setLabel("Identify Yourself")
     .hide();
  
  unlock = cp5.addButton("unlock",1,width/4, height-40,width/2, 30)
     .setLabel("Unlock File")
     .hide();
  
  lock = cp5.addButton("lock",1,width/4, height-40,width/2, 30)
     .setLabel("Lock File")
     .hide();
     
  textFont(createFont("",50));
  
  label1 = cp5.addTextlabel("label_rec")
                  .setText("You are being identified. Please wait.")
                  .setPosition(width/4, height-40)
                  .setColorValue(255)
                  .setFont(createFont("",20))
                  .hide();
                  
  label2 = cp5.addTextlabel("label_drop")
                  .setText("Drop files here to lock.")
                  .setPosition(width/4, 40)
                  .setColorValue(255)
                  .setFont(createFont("",20))
                  .hide();
  
  // start learning from samples                
  run_recognizer();
                  
  unit = width/num;
}

void draw() {
  switch(options) {
    case 0: //Display 0: Entry
      fill(0,30);
      noStroke();
      rect(0,0,width, height);
      fill(255);
      for (int y=0; y<=num; y++) {
        for (int x=0; x<=num; x++) {
          float distance = dist(width/2, height/2, x*unit, y*unit);
          float offSet = map(distance, 0, sqrt(sq(width/2)+sq(height/2)), 0, TWO_PI);
          float sz = map(sin(theta+offSet), -1, 1, unit*.2, unit*.1);
          float angle = atan2(y*unit-height/2, x*unit-width/2);
          pushMatrix();
          translate(x*unit, y*unit);
          rotate(angle);
          float px = map(sin(theta+offSet),-1,1,0,50);
          ellipse(px,0, sz, sz);
          popMatrix();
        }
      }
      stroke(255);
    
      theta -= TWO_PI/frames;
      if(!flag){
        b.show();
      }
      else {

        //label2.show();
        if(locked)
        unlock.show();
        else
        lock.show();
        //m.draw();
      }
      break;
      
    case 1: //Display 1: Identify
      b.hide();
      //background(0);
      //pushMatrix();
      //translate(width/2, height/2, 0);
      //rotateX(300 * 0.05);
      //rotateY(155 * 0.05);
      //noStroke();
      //fill(255);
      //lights();
      //sphere(80);
      
      //translate(25, 0, 25);
      //fill(150);
      //sphere(50);
      
      //translate(30, 0, 30);
      //fill(0);
      //sphere(15);
      //popMatrix();
      
      //label1.show();
      
      options = 2;
      break;
      
    case 2: //Run recognizer
      //run_recognizer();
        // test a new image
        testNewImage();
      if(matchFound) {
        println("Match Found");
        options = 3;
        //b.show();
      }
      else {
        println("No Match Found");
        options = 0;
        b.show();
      }
      break;
      
    case 3: //open locks and show locked files
      flag = true;
      options = 0;
      
  }

}

//void keyPressed() {
//  flag = !flag;
//  if(flag){
//    draw();
//  }
//}

void identify(int value) {
  options = 1; // Start Identifying
}

void unlock(int value) {
  unlock.hide();
  locked = false;
  try{
      Process r = Runtime.getRuntime().exec("icacls \"C:\\Users\\himanshu_agg\\Desktop\\FACE_TEST.txt\" /grant:r himanshu\\himanshu_agg:F");
      } catch (Exception err) {
      err.printStackTrace();
      }
  launch("C:\\Users\\himanshu_agg\\Desktop\\FACE_TEST.txt");
}

void lock(int value) {
  lock.hide();
  locked = true;
  try{
      Process r = Runtime.getRuntime().exec("icacls \"C:\\Users\\himanshu_agg\\Desktop\\FACE_TEST.txt\" /deny himanshu\\himanshu_agg:F");
      } catch (Exception err) {
      err.printStackTrace();
      }
}