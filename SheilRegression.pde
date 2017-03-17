

//Rafael Morales (rafael.morales@inria.fr)


import java.util.Arrays;

class SheilRegression {

    public SheilRegression()
    {

    }
//    * @return [y intercept, slope, 2.5 percentile, 97.5 percentile, number of pairs]
    public double[] getSheilRegression(ArrayList<Double> v1, ArrayList<Double> v2) {

        if (v1.size() != v2.size()) {
            throw new IllegalArgumentException("Arrays must be of the same length " + v1.size() + ", " + v2.size());
        }

        ArrayList<Double> slopesList = new ArrayList<Double>();
        int cnt = 0;
        for (int i = 0; i < v1.size(); i++) {
            double x = v1.get(i);
            double y = v2.get(i);
            for (int j = i + 1; j < v1.size(); j++) {
                if (x != v1.get(j)) { // x must be different, otherwise slope becomes infinite
                    double slope = (v2.get(j) - y) / (v1.get(j) - x);
                    slopesList.add(slope);
                    ++cnt;
                }
            }
        }
        double[] slopes = new double[slopesList.size()];
        for(int i=0; i<slopesList.size(); i++)
        {
            slopes[i] = slopesList.get(i);
        }
        double[] medianv1 = new double[v1.size()];
        for(int i=0; i<v1.size(); i++)
        {
            medianv1[i] = v1.get(i);
        }
        double median1 = median(medianv1);
        double[] medianv2 = new double[v2.size()];
        for(int i=0; i<v2.size(); i++)
        {
            medianv1[i] = v2.get(i);
        }
        double median2 = median(medianv2);
        double slope = median(slopes);
        double yI = median2 - slope * median1;
        double p1 = percentile(slopes, 0.025d);
        double p2 = percentile(slopes, 0.975d);

        return new double[]{yI, slope, p1, p2, cnt};

    }
//    * @return [y intercept, slope, 2.5 percentile, 97.5 percentile, number of pairs]
    public double[] getSheilRegression(ArrayList<Double> v1) {

        if(v1.size()==0)
        {
            throw new IllegalArgumentException("Array must be more than 0 " + v1.size());
        }
        ArrayList<Double> v2 = new ArrayList<Double>();
        for(int i = 0; i<v1.size();i++)
        {
            v2.add(i,(double)i);
        }

        ArrayList<Double> slopesList = new ArrayList<Double>();
        int cnt = 0;
        for (int i = 0; i < v1.size(); i++) {
            double x = v2.get(i);
            double y = v1.get(i);
            for (int j = i + 1; j < v1.size(); j++) {
                if (x != v1.get(j)) { // x must be different, otherwise slope becomes infinite
                    double slope = (v1.get(j) - y) / (v2.get(j) - x);
                    slopesList.add(slope);
                    ++cnt;
                }
            }
        }
        double[] slopes = new double[slopesList.size()];
        for(int i=0; i<slopesList.size(); i++)
        {
            slopes[i] = slopesList.get(i);
        }
        double[] medianv1 = new double[v1.size()];
        for(int i=0; i<v1.size(); i++)
        {
            medianv1[i] = v1.get(i);
        }
        double median1 = median(medianv1);
        double[] medianv2 = new double[v2.size()];
        for(int i=0; i<v2.size(); i++)
        {
            medianv2[i] = v2.get(i);
        }
        double median2 = median(medianv2);
        double slope = median(slopes);
        double yI = median2 - slope * median1;
        double p1 = percentile(slopes, 0.025d);
        double p2 = percentile(slopes, 0.975d);

        return new double[]{yI, slope, p1, p2, cnt};

    }
    private double median(double[] a) {
    double[] b = new double[a.length];
    System.arraycopy(a, 0, b, 0, b.length);
    //Arrays.sort(b);
    int mid = b.length / 2;
    if (b.length % 2 == 0) {
      return (b[mid - 1] + b[mid]) / 2.0;
    } else {
      return b[mid];
    }
    
    }
    private double percentile(double[] x,double p) {
    int rp = (int) Math.round(p*((double) x.length));
    
    double[] y = x;
    Arrays.sort(y);
    return y[rp];
  }
}