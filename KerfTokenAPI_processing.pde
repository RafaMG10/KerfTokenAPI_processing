//Rafael Morales (rafael.morales@inria.fr)

import TUIO.*;

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
  //SheilRegression s = new SheilRegression();
}

void draw()
{
}