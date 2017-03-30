//Rafael Morales (rafael.morales@inria.fr)

import TUIO.*;

public int inputWidth = 105;// 198; // 105; // 720;
TuioProcessing tuioClient;
boolean verbose = false; // print console debug messages
boolean callback = false; // updates only after callbacks
boolean debug = false; // debugging


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

  public ArrayList<TouchPoint> fingers = new ArrayList<TouchPoint>();
  protected int dwellDuration = 200; // in ms
  protected double dwellTolerance = 3; // in mm

  protected long dwellStartTime = -1;
  protected long lastUpdateTime = -1;
  protected long time ;
  double SCREEN_RES;
  PShape s;
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
  SCREEN_RES = 113 / 25.4;
  //ArrayList<TouchPoint> points = new ArrayList<TouchPoint>();
  //points.add(new TouchPoint(30,30));
  //points.add(new TouchPoint(90,90));
  //points.add(new TouchPoint(100,450));
  //TokenTemplate tt =recognizer.recognize(points);
  //println("recognizer is: " + tt.tokenID);
  tuioClient  = new TuioProcessing(this);
  //SheilRegression s = new SheilRegression();
  
  
}

void draw()
{
  
  if(tokenDown!=null)
  {
    println("tokenDown " + tokenDown);
    TouchPoint center = getTokenCenter(currentTemplate,fingers);
    ellipse((float)(center.x * width ),
            (float)(center.y * height ), 20, 20);
    //translate((float)center.x, (float)center.y);
    //PShape s = currentTemplate.getTokenOutline();
  //fo//r (int i = 0; i < s.getVertexCount(); i++) {
    //PVector v = s.getVertex(i);
    //v.x += random(-1, 1);
    //v.y += random(-1, 1);
    //s.setVertex(i, v);
  //}
    shape(s);
    for (Iterator<TouchPoint> iterator = fingers.iterator(); iterator.hasNext();) {
      TouchPoint point = iterator.next();
      if(point != null) {
        println("point " + point);
        double dx = point.x - center.x;
        double dy = point.y - center.y;
        double dxInMM = dx * width;
        double dyInMM = dy * height;
        double dxInWindow = dxInMM * SCREEN_RES;
        double dyInWindow = dyInMM * SCREEN_RES;
        
        ellipse((float)(point.x * width ),
            (float)(point.y * height ), 20, 20);
      }
    }
    
  }else
  {
    println("tokenDown " + tokenDown);
    background(251);
    //recognizingToken();
  }
}

void recognizingToken()
{
  //long currentTime = millis();
      //if((currentTime - dwellStartTime) >= dwellDuration && (lastUpdateTime - dwellStartTime) < dwellDuration) {
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
        if(inputInMms.size() == 3) 
        {
          TokenRecognizer recognizer = new TokenRecognizer("templates.txt");
          //println("size point" + inputInMms.size());
          for (int i = 0; i < inputInMms.size(); i++) {
            //println(" point in Mms " +inputInMms.get(i));
          }
          currentTemplate = recognizer.recognize(inputInMms);
          fingers = inputIn01;
          s = currentTemplate.getTokenOutline();
          println("S:" + s);
        }

        if(debug) {
          System.out.println("recognized as: "+currentTemplate);
        }
        if(currentTemplate != null) {
          long time1 = millis();
          time = millis();
          tokenDown = currentTemplate.getTokenID();
          println("tokenDown " + tokenDown);
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
      //}// end the timer
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
    recognizingToken();
    //dwellStartTime = System.currentTimeMillis();
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
    println("tokenDown must be null");
    tokenDown = null;
    currentTemplate = null;
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
      //System.out.println("finger count " + fingerCount);
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
public TouchPoint getTokenCenter(TokenTemplate transformedTemplate, ArrayList<TouchPoint> tokenPoints) {
        TouchPoint centerTemplate = new TouchPoint(transformedTemplate.getCenter().x, transformedTemplate.getCenter().y);
        TouchPoint pt1Template = new TouchPoint(transformedTemplate.getPoints().get(0).x, transformedTemplate.getPoints().get(0).y);
        TouchPoint pt2Template = new TouchPoint(transformedTemplate.getPoints().get(1).x, transformedTemplate.getPoints().get(1).y);
        TouchPoint v1CenterTemplate = new TouchPoint(centerTemplate.x - pt1Template.x, centerTemplate.y - pt1Template.y);
        TouchPoint v12Template = new TouchPoint(pt2Template.x - pt1Template.x, pt2Template.y - pt1Template.y);

        double angle21Center = angleBetweenVectors(v12Template, v1CenterTemplate);

        TouchPoint pt1Token = tokenPoints.get(0);
        pt1Token = new TouchPoint(pt1Token.x*inputWidth, pt1Token.y*inputHeight);
        TouchPoint pt2Token = tokenPoints.get(1);
        pt2Token = new TouchPoint(pt2Token.x*inputWidth, pt2Token.y*inputWidth);
        TouchPoint v12Token = new TouchPoint(pt2Token.x - pt1Token.x, pt2Token.y - pt1Token.y);
        double x12Token = angleBetweenVectors(new TouchPoint(1, 0), v12Token);

        double length1Center =
                Math.sqrt((centerTemplate.x - pt1Template.x) * (centerTemplate.x - pt1Template.x) +
                        (centerTemplate.y - pt1Template.y) * (centerTemplate.y - pt1Template.y));

        TouchPoint centerToken = new TouchPoint(length1Center, 0);
        centerToken.setLocation(centerToken.x + pt1Token.getX(), centerToken.y + pt1Token.getY());
        double angle = x12Token + angle21Center;
        rotateBy(centerToken, pt1Token, angle, centerToken);
        centerToken.setLocation(centerToken.x/inputWidth, centerToken.y/inputHeight);
        return centerToken;
    }
    public  double angleBetweenVectors(TouchPoint vector1, TouchPoint vector2) {
    double angle = Math.atan2(vector2.getY(), vector2.getX()) - Math.atan2(vector1.getY(), vector1.getX());
    //  normalize to the range 0 .. 2 * Pi:
    if (angle < 0) angle += 2 * Math.PI;
    return angle;
    }
    
    public void rotateBy(TouchPoint point, TouchPoint refPoint, double theta, TouchPoint newPoint) {
    double x = (point.getX() - refPoint.getX()) * Math.cos(theta) - (point.getY() - refPoint.getY()) * Math.sin(theta) + refPoint.getX();
    double y = (point.getX() - refPoint.getX()) * Math.sin(theta) + (point.getY() - refPoint.getY()) * Math.cos(theta) + refPoint.getY();
    newPoint.setLocation(x, y);
  }
  