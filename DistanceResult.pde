//Rafael Morales (rafael.morales@inria.fr)

class DistanceResult {

    protected double angle;
    protected double distance;

    public DistanceResult(double angle, double distance) {
        this.angle = angle;
        this.distance = distance;
    }

    public double getAngle() {
        return angle;
    }

    public void setAngle(double angle) {
        this.angle = angle;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }

}