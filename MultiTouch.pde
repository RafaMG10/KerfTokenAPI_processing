//Rafael Morales (rafael.morales@inria.fr)

class MultiTouchInput {

  protected ArrayList<TouchPoint> points;

  public MultiTouchInput(ArrayList<TouchPoint> points) {
    this.points = points;
  }

  public ArrayList<TouchPoint> getPoints() {
    return points;
  }

  public String toString() {
    String points = "[";
    for (TouchPoint pt : this.points) {
      points += "("+(int)pt.getX()+","+(int)pt.getY()+")";
    }
    points += "]";
    return points;
  }
}