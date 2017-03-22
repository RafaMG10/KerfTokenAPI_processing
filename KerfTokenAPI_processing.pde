//Rafael Morales (rafael.morales@inria.fr)

import TUIO.*;

public int inputWidth = 105;// 198; // 105; // 720;
TuioProcessing tuioClient;
boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks
boolean debug = true; // debugging


protected TokenRecognizer recognizer;
  protected String tokenDown = null;

  protected TouchPoint centre = new TouchPoint();
  
  //protected Buffer_Bend bufferBend = new Buffer_Bend();
  //protected Buffer_Squeeze bufferSqueeze = new Buffer_Squeeze();
  //protected Buffer_Surface buffer_surface = new Buffer_Surface();
  
  //protected double inputWidth = -1;
  //protected double inputHeight = -1;

  protected static TouchPoint[] FINGERS_LOCATION = new TouchPoint[10];
  protected static TouchPoint[] FINGERS_LOCATION_AT_TIMER_START_TIME = new TouchPoint[10];

  protected int dwellDuration = 200; // in ms
  protected double dwellTolerance = 3; // in mm

  protected long dwellStartTime = -1;
  protected long lastUpdateTime = -1;
  protected long time ;

  protected ArrayList<Integer> indices = new ArrayList<Integer>();

  protected TouchPoint centre_token;
  protected ArrayList<TouchPoint> notchPointsAtDown;
  protected TokenTemplate currentTemplate;

//    @Option(name = "-inputHeight", usage = "height of tactile surface in mm")
public int inputHeight = 75;//148; // 75; // 396

void setup()
{
  // GUI setup
  size(600, 600);
  noFill();
  strokeCap(SQUARE);
  TokenRecognizer recognizer = new TokenRecognizer("templates.txt");
  ArrayList<TouchPoint> points = new ArrayList<TouchPoint>();
  points.add(new TouchPoint(30,30));
  points.add(new TouchPoint(90,90));
  points.add(new TouchPoint(100,450));
  TokenTemplate tt =recognizer.recognize(points);
  println("recognizer is: " + tt.tokenID);
  tuioClient  = new TuioProcessing(this);
  //SheilRegression s = new SheilRegression();
  
  
}

void draw()
{
  
  if(tokenDown!=null)
  {
    println("holaaaaa");
    println("TokenDown " + tokenDown);
  }else
  {
    //recognizingToken();
  }
}

void recognizingToken()
{
  long currentTime = millis();
      if((currentTime - dwellStartTime) >= dwellDuration && (lastUpdateTime - dwellStartTime) < dwellDuration) {
        ArrayList<TouchPoint> inputInMms = new ArrayList<TouchPoint>(); // the recognizer stores templates in mm
        ArrayList<TouchPoint> inputIn01 = new ArrayList<TouchPoint>();
        indices.clear();
        for (int i = 0; i < FINGERS_LOCATION.length; i++) {
          if(FINGERS_LOCATION[i] != null) {
            indices.add(i);
            inputInMms.add(new TouchPoint(FINGERS_LOCATION[i].x * inputWidth, FINGERS_LOCATION[i].y * inputHeight));
            inputIn01.add(new TouchPoint(FINGERS_LOCATION[i].x, FINGERS_LOCATION[i].y));
          }
        }
        if(debug) {
          System.out.println("input: "+inputInMms);
        }
        currentTemplate = recognizer.recognize(inputInMms);

        if(debug) {
          System.out.println("recognized as: "+currentTemplate);
        }
        if(currentTemplate != null) {
          long time1 = millis();
          time = millis();
          tokenDown = currentTemplate.getTokenID();
          //fireTokenDown(tokenDown, inputIn01, inputWidth, inputHeight, currentTemplate);
          
          //add point to the bend's buffer
                    ArrayList<TouchPoint> tokenPoints = new ArrayList<TouchPoint>(inputIn01);

          //TouchPoint tokenCenter = getTokenCenter(currentTemplate, tokenPoints);
          //          TouchPoint tcenterMm = new TouchPoint(tokenCenter.getX()*inputWidth,tokenCenter.getY()*inputHeight);
          //          centre_token = getTokenCenter(currentTemplate, tokenPoints);
                    
          //int numFingers = numberOfFingers(inputIn01);
          //ArrayList<TouchPoint> touchPointsMm = new ArrayList<TouchPoint>();
          //          for(int i = 0; i < inputIn01.size(); i++)
          //          {
          //              TouchPoint p = inputIn01.get(i);
          //              if (p!=null)
          //              {
          //                  touchPointsMm.add(new TouchPoint(p.getX()*inputWidth,p.getY()*inputHeight));
          //              }
          //          }
          //double distance = distances(touchPointsMm,tokenCenter)/numFingers;
          //bufferBend.updateBuffer(time1 - time,distance);
          //          bufferBend.updateState(numFingers,time1 - time);
          //          bufferSqueeze.shifted(time, numFingers, distance, tcenterMm);
          //          buffer_surface.addDist(distance,time1);
        }
      }
      lastUpdateTime = millis();
}
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
void addTuioCursor(TuioCursor arg0) {
  if (verbose) println("add cur "+arg0.getCursorID()+" ("+arg0.getSessionID()+ ") " +arg0.getX()+" "+arg0.getY());
  
  //System.out.println("hola");
    int cursorID = arg0.getCursorID();
    FINGERS_LOCATION[cursorID] = new TouchPoint(arg0.getX(), arg0.getY());
    if(debug) {
      System.out.println("+ tuio cursor "+arg0.getCursorID()+": ("+arg0.getX()+", "+arg0.getY()+")");
    }
    for (int i = 0; i < FINGERS_LOCATION.length; i++) {
      FINGERS_LOCATION_AT_TIMER_START_TIME[i] = FINGERS_LOCATION[i];
    }
    dwellStartTime = System.currentTimeMillis();
  }

protected void tokenUp() {
  if(tokenDown != null) {
    dwellStartTime = -1;
    ArrayList<TouchPoint> inputIn01 = new ArrayList<TouchPoint>();
    for (int i = 0; i < FINGERS_LOCATION.length; i++) {
      if(FINGERS_LOCATION[i] != null) {
        inputIn01.add(new TouchPoint(FINGERS_LOCATION[i].x, FINGERS_LOCATION[i].y));
      } else if(indices.contains(i)) {
        inputIn01.add(null);
      }
    }
    //fireTokenUp(tokenDown, inputIn01, inputWidth, inputHeight, currentTemplate);
    tokenDown = null;
  }

redraw();
}
//protected void fireTokenUp(String tokenID, ArrayList<TouchPoint> points, double deviceWidth, double deviceHeight, TokenTemplate transformedTemplate) {
  
//}
// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  int cursorID = tcur.getCursorID();

    FINGERS_LOCATION[cursorID] = new TouchPoint(tcur.getX(), tcur.getY());

    if(debug) {
      System.out.println("~ tuio cursor "+tcur.getCursorID()+": ("+tcur.getX()+", "+tcur.getY()+")");
    }

    // sometimes, MT events are not delivered in the right order, avoid null exception:
    if(FINGERS_LOCATION_AT_TIMER_START_TIME[cursorID] == null) {
      FINGERS_LOCATION_AT_TIMER_START_TIME[cursorID] = FINGERS_LOCATION[cursorID];
    }

    TouchPoint pointNow = new TouchPoint(FINGERS_LOCATION[cursorID].x * inputWidth, FINGERS_LOCATION[cursorID].y * inputHeight);
    TouchPoint pointAtTimerStartTime = new TouchPoint(FINGERS_LOCATION_AT_TIMER_START_TIME[cursorID].x * inputWidth, FINGERS_LOCATION_AT_TIMER_START_TIME[cursorID].y * inputHeight);

    double distance = pointNow.distance(pointAtTimerStartTime);

    //println("distance " + distance);
    //println("dwellTolerance " + dwellTolerance);
    boolean dwelling = distance < dwellTolerance;
    //println("dwelling " + dwelling);
    if(!dwelling) {
      for (int i = 0; i < FINGERS_LOCATION.length; i++) {
        FINGERS_LOCATION_AT_TIMER_START_TIME[i] = FINGERS_LOCATION[i];
      }
      dwellStartTime = System.currentTimeMillis();
    }

    ArrayList<TouchPoint> inputIn01 = new ArrayList<TouchPoint>();
    for (int i = 0; i < FINGERS_LOCATION.length; i++) {
      if(FINGERS_LOCATION[i] != null) {
        inputIn01.add(new TouchPoint(FINGERS_LOCATION[i].x, FINGERS_LOCATION[i].y));
      } else if(indices.contains(i)) {
        inputIn01.add(null);
      }
    }
    if(tokenDown != null) {
      fireTokenMoved(tokenDown, inputIn01, inputWidth, inputHeight, currentTemplate);
    }
  redraw();
}
protected void fireTokenMoved(String tokenID, ArrayList<TouchPoint> points, double deviceWidth, double deviceHeight, TokenTemplate transformedTemplate) {
//  
ArrayList<TouchPoint> tokenPoints = new ArrayList<TouchPoint>();
    int pointsCount = 0;
    for (Iterator<TouchPoint> iterator = points.iterator(); iterator.hasNext();) {
      TouchPoint touchPoint = iterator.next();
      tokenPoints.add(touchPoint);
      if(touchPoint != null) {
        pointsCount++;
      }
    }
    if(pointsCount == 0) {
      tokenUp();
    }
    //if(pointsCount == 2) {
    //  complementNotchPoints(notchPointsAtDown, tokenPoints, deviceWidth, deviceHeight);
    //}
    //if(pointsCount == 1 || pointsCount == 2 || pointsCount == 3 ) {
      if( pointsCount == 2 || pointsCount == 3 ) {
        
//      System.out.println("moving....");
//      TokenEvent tokenEvent = new TokenEvent(this, tokenID, points, tokenPoints, deviceWidth, deviceHeight, transformedTemplate, recognizer.getTemplate(transformedTemplate.getTokenID()));
//      for (Iterator<TokenListener> iterator = listeners.iterator(); iterator.hasNext();) {
//        TokenListener tokenListener = iterator.next();
//        tokenListener.tokenMoved(tokenEvent);
      }
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  int cursorID = tcur.getCursorID();
    int fingerCount = 0;
    for (int i = 0; i < FINGERS_LOCATION.length; i++) {
      if(FINGERS_LOCATION[i] != null) {
        fingerCount++;
      }
    }
    
    if(fingerCount == 1) {
//      System.out.println("finger count " + fingerCount);
      tokenUp();
    } else {
      dwellStartTime = System.currentTimeMillis();
    }
    FINGERS_LOCATION[cursorID] = null;
    if(debug) {
      System.out.println("- tuio cursor "+tcur.getCursorID()+": ("+tcur.getX()+", "+tcur.getY()+")");
    }
    for (int i = 0; i < FINGERS_LOCATION.length; i++) {
      FINGERS_LOCATION_AT_TIMER_START_TIME[i] = FINGERS_LOCATION[i];
    }

  
  redraw();
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