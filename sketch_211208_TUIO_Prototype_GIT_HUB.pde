//import dedicated libraries
import http.requests.*;
import TUIO.*;

//declare type and variable arguments + clients
TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
String apiKey = "bnkWY8-JrKulNmQqcFVTDD";
String eventNameRED = "SmartBulb1_Red";
String eventNameTEAL = "SmartBulb2_Teal";
String eventCurrent1 = "SmartBulb1_SoftWhite";
String eventCurrent2 = "SmartBulb2_SoftWhite";
String SpotifySink = "Sink_Play";
String SpotifyStove = "Stove_Play";

float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;
PImage photo;
color backgroundColor = color(255);

int xseg = 4; //screen segments
int xpos1 = 1;
int xpos2 = (width/xseg);
int xpos3 = (width/xseg*2);
int xpos4 = (width/xseg*3);
int xpos5 = (width);

String lastZone = "";
String currentZone = "";

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

void setup() {
  // GUI setup
  noCursor();
  noStroke();
  fill(0);
  size(1000, 750);
  
    // periodic updates
  if (!callback) {
    frameRate(60);
    loop();
  } else noLoop(); // or callback updates 
  
  font = createFont("Arial", 18);
  scale_factor = height/table_size;
  
  tuioClient  = new TuioProcessing(this);
}

void draw() {
  background(backgroundColor);
  textFont(font,18*scale_factor);
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 
   
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0;i<tuioObjectList.size();i++) {
     TuioObject tobj = tuioObjectList.get(i);
     stroke(0);
     noFill();
     fill(0,0,0);
     pushMatrix();
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
     rotate(tobj.getAngle());
     rect(-obj_size/2,-obj_size/2,obj_size,obj_size);
     popMatrix();
     fill(255);
     text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
     
     if ((tobj.getScreenX(width) > xpos1)  && (tobj.getScreenX(width) < (width/xseg))) {  //Jacob's sink location, left most pixels
       currentZone = "zoneA";

     } else if ((tobj.getScreenX(width) > (width/xseg))  && (tobj.getScreenX(width) < (width/xseg*2))) {
       currentZone = "zoneB";
       
     } else if  ((tobj.getScreenX(width) > (width/xseg*2))  && (tobj.getScreenX(width) < (width/xseg*3))) {
       currentZone = "zoneC";
       
     } else if ((tobj.getScreenX(width) > (width/xseg*3))  && (tobj.getScreenX(width) < (width/xseg*4))) {  //Jacobs stove location, right most pixels
       currentZone = "zoneD";
     }
     
     if (lastZone == ""){
       lastZone = currentZone;       
       if (currentZone == "zoneA"){
         //Kylies's Sink
           background(0, 0, 255);
           GetRequest get = new GetRequest("https://maker.ifttt.com/trigger/" + eventNameTEAL + "/with/key/" + apiKey);
           get.send();
           
           GetRequest get1 = new GetRequest("https://maker.ifttt.com/trigger/" + eventCurrent1 + "/with/key/" + apiKey);
           get1.send();
           
           GetRequest getSink = new GetRequest("https://maker.ifttt.com/trigger/" + SpotifySink + "/with/key/" + apiKey);
           getSink.send();
           
       } else if (currentZone == "zoneB"){
         //DO SOMETHING
         
       } else if (currentZone == "zoneC"){
         //DO SOMETHING
         
       } else if (currentZone == "zoneD"){
         //DO SOMETHING
           background(255, 0, 0);
           GetRequest get = new
           GetRequest("https://maker.ifttt.com/trigger/" + eventNameRED + "/with/key/" + apiKey);
           get.send();
           
           GetRequest get2 = new
           GetRequest("https://maker.ifttt.com/trigger/" + eventCurrent2 + "/with/key/" + apiKey);
           get2.send();
           
           GetRequest getStove = new
           GetRequest("https://maker.ifttt.com/trigger/" + SpotifyStove + "/with/key/" + apiKey);
           getStove.send();
       
         
       }
     } else if (lastZone != currentZone){
       lastZone = currentZone;
       if (currentZone == "zoneA"){
         //DO SOMETHING
           background(0, 0, 255);
           GetRequest get = new GetRequest("https://maker.ifttt.com/trigger/" + eventNameTEAL + "/with/key/" + apiKey);
           get.send();
           
           GetRequest get1 = new GetRequest("https://maker.ifttt.com/trigger/" + eventCurrent1 + "/with/key/" + apiKey);
           get1.send();
           
           GetRequest getSink = new GetRequest("https://maker.ifttt.com/trigger/" + SpotifySink + "/with/key/" + apiKey);
           getSink.send();
            
           noLoop();
       } else if (currentZone == "zoneB"){
         //DO SOMETHING
         
       } else if (currentZone == "zoneC"){
         //DO SOMETHING
         
       } else if (currentZone == "zoneD"){
         //Kylies's Stove
           background(255, 0, 0);
           GetRequest get = new
           GetRequest("https://maker.ifttt.com/trigger/" + eventNameRED + "/with/key/" + apiKey);
           get.send();
           
           GetRequest get2 = new
           GetRequest("https://maker.ifttt.com/trigger/" + eventCurrent2 + "/with/key/" + apiKey);
           get2.send();
           
           GetRequest getStove = new
           GetRequest("https://maker.ifttt.com/trigger/" + SpotifyStove + "/with/key/" + apiKey);
           getStove.send();
       }
     }
  }
  
   ArrayList<TuioCursor> tuioCursorList = tuioClient.getTuioCursorList();
   for (int i=0;i<tuioCursorList.size();i++) {
      TuioCursor tcur = tuioCursorList.get(i);
      ArrayList<TuioPoint> pointList = tcur.getPath();
      
      if (pointList.size()>0) {
        stroke(0,0,255);
        TuioPoint start_point = pointList.get(0);
        for (int j=0;j<pointList.size();j++) {
           TuioPoint end_point = pointList.get(j);
           line(start_point.getScreenX(width),start_point.getScreenY(height),end_point.getScreenX(width),end_point.getScreenY(height));
           start_point = end_point;
        }
        
        stroke(192,192,192);
        fill(192,192,192);
        ellipse( tcur.getScreenX(width), tcur.getScreenY(height),cur_size,cur_size);
        fill(0);
        text(""+ tcur.getCursorID(),  tcur.getScreenX(width)-5,  tcur.getScreenY(height)+5);
      }
   }
   
  ArrayList<TuioBlob> tuioBlobList = tuioClient.getTuioBlobList();
  for (int i=0;i<tuioBlobList.size();i++) {
     TuioBlob tblb = tuioBlobList.get(i);
     stroke(0);
     fill(0);
     pushMatrix();
     translate(tblb.getScreenX(width),tblb.getScreenY(height));
     rotate(tblb.getAngle());
     ellipse(-1*tblb.getScreenWidth(width)/2,-1*tblb.getScreenHeight(height)/2, tblb.getScreenWidth(width), tblb.getScreenWidth(width));
     popMatrix();
     fill(255);
     text(""+tblb.getBlobID(), tblb.getScreenX(width), tblb.getScreenX(width));
   }  

 } //End of draw loop
  
// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
          +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}


//--------------------------------------------------------------
