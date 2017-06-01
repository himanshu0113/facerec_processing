

void dropEvent(DropEvent theDropEvent) {}

class MyDropListener extends DropListener {
  
  int myColor;
  File path;
  
  MyDropListener() {
    myColor = color(200);
    // set a target rect for drop event.
    setTargetRect(width/4, 40, width*3/4, 80);
  }
  
  void draw() {
    fill(myColor);
    rect(10,10,100,100);
  }
  
  // if a dragged object enters the target area.
  // dropEnter is called.
  void dropEnter() {
    myColor = color(255,0,0);
  }
  
  // if a dragged object leaves the target area.
  // dropLeave is called.
  void dropLeave() {
    myColor = color(255);
  }
  
  void dropEvent(DropEvent theEvent) {
    println("Dropped on MyDropListener");
    
    if(theEvent.isFile()){ 
      path = theEvent.file();
    }
    try {
    //Process p = Runtime.getRuntime().exec("cmd /c cd ..");
    //Process p = Runtime.getRuntime().exec("icacls \"C:\\Users\\himanshu_agg\\Desktop\\FACE_TEST.txt\" /save Myacl__backup.txt");
    //Process r = Runtime.getRuntime().exec("icacls \"C:\\Users\\himanshu_agg\\Desktop\\FACE_TEST.txt\" /deny himanshu\\himanshu_agg:F");
    Process r = Runtime.getRuntime().exec("icacls "+ path +" /deny himanshu\\himanshu_agg:F");
    //Process b = Runtime.getRuntime().exec("icacls \"C:\\Users\\himanshu_agg\\Desktop\\FACE_TEST.txt\" /restore Myacl_backup.txt");
      
    } catch (Exception err) {
      err.printStackTrace();
    }
    
    
  }
}