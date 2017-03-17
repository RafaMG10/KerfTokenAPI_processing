import TUIO.*;

void setup()
{
  // GUI setup
  noCursor();
  size(displayWidth,displayHeight);
  noStroke();
  fill(0);
  
  
  
  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
}

void draw()
{
}