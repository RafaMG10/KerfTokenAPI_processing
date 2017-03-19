import java.util.*; 
class ComparatorByPoints implements Comparator{ 
  public int compare(Object pt11, Object pt22)  {
         TouchPoint vectorXAxis = new TouchPoint(10, 0);
         TouchPoint pt1 = (TouchPoint)pt11;
         TouchPoint pt2 = (TouchPoint)pt22;
        TouchPoint vector1 = new TouchPoint(pt1.getX(), pt1.getY());
        double angle1 = angleBetweenVectors(vectorXAxis, vector1);
        TouchPoint vector2 = new TouchPoint(pt2.getX() , pt2.getY() );
        double angle2 = angleBetweenVectors(vectorXAxis, vector2);
        return (int)((angle2 - angle1)*100);
      }
     public  double angleBetweenVectors(TouchPoint vector1, TouchPoint vector2) {
    double angle = Math.atan2(vector2.getY(), vector2.getX()) - Math.atan2(vector1.getY(), vector1.getX());
    //  normalize to the range 0 .. 2 * Pi:
    if (angle < 0) angle += 2 * Math.PI;
    return angle;
  }
}