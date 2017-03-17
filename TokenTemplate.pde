//Rafael Morales (rafael.morales@inria.fr)

class TokenTemplate extends MultiTouchInput {

  protected String tokenID;

  protected double distance;
  protected double angle;

  protected TouchPoint center;
  protected PShape tokenOutline;

  protected TokenTemplate originalGeometryTemplate;

  public TokenTemplate(ArrayList<TouchPoint> points, String tokenID, TouchPoint center) {
    super(points);
    this.points = points;
    this.tokenID = tokenID;
    this.center = center;
    this.angle = 0;
    this.distance = 0;
  }

  public String toString() {
    String points = "";
    for (TouchPoint pt : this.points) {
      points += "("+pt.getX()+","+pt.getY()+")";
    }
    points += "";
    return tokenID+" ["+points+"]";
  }

  public ArrayList<TouchPoint> getPoints() {
    return points;
  }

  public void setPoints(ArrayList<TouchPoint> points) {
    this.points = points;
  }

  public String getTokenID() {
    return tokenID;
  }

  public void setTokenID(String tokenID) {
    this.tokenID = tokenID;
  }

  public double getDistance() {
    return distance;
  }

  public void setDistance(double distance) {
    this.distance = distance;
  }

  public TouchPoint getCenter() {
    return center;
  }

  public void setCenter(TouchPoint center) {
    this.center = center;
  }

  public TokenTemplate getOriginalGeometryTemplate() {
    return originalGeometryTemplate;
  }

  public void setOriginalGeometryTemplate(TokenTemplate originalGeometryTemplate) {
    this.originalGeometryTemplate = originalGeometryTemplate;
  }

  public PShape getTokenOutline() {
    return tokenOutline;
  }

  public void setTokenOutline(PShape tokenOutline) {
    this.tokenOutline = tokenOutline;
  }

  public double getAngle() {
    return angle;
  }

  public void setAngle(double angle) {
    this.angle = angle;
  }

}