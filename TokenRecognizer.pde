//Rafael Morales (rafael.morales@inria.fr)

class TokenRecognizer {

  protected ArrayList<TokenTemplate> tokenTemplates;

  public TokenRecognizer() {
    this.tokenTemplates = new ArrayList<TokenTemplate>();
  }

  public TokenRecognizer(String templatesFile) {
    this.tokenTemplates = new ArrayList<TokenTemplate>();
    
      String[] lines = loadStrings(templatesFile);
      //BufferedReader br = new BufferedReader(new FileReader(templatesFile));
      //String line = br.readLine();
      //DecimalFormat df = new DecimalFormat();
      //DecimalFormatSymbols symbols = new DecimalFormatSymbols();
      //symbols.setDecimalSeparator('.');
      //symbols.setGroupingSeparator(',');
      //df.setDecimalFormatSymbols(symbols);
      float x, y;
      int index = 0 ;
      while (index < lines.length) {
        println(lines[index]);
        String[] parts = lines[index].split(",");
        
        ////        System.out.println(line);
        ////if (!line.startsWith("#")) {
        //  //String[] parts = line.split(",");
        if (parts.length > 3) {
            String tokenID = parts[0];
            int fingerCount = Integer.parseInt(parts[1]);
            ArrayList<TouchPoint> points = new ArrayList<TouchPoint>();
            for (int i = 0; i < fingerCount; i++) {
              x = Float.parseFloat(parts[2+(i*2)]);
              y = Float.parseFloat(parts[2+(i*2)+1]);
              TouchPoint point = new TouchPoint(x, y);
              points.add(point);
            }
            TouchPoint center = new TouchPoint(0, 0);
            if(parts.length > (2+(fingerCount*2))) {
              double centerx = Double.parseDouble(parts[2+(fingerCount*2)]);
              double centery = Double.parseDouble(parts[2+(fingerCount*2)+1]);
              center.setLocation(centerx, centery);
              System.out.println("CENTER provided ("+centerx+", "+centery+")");
            } else {
              System.out.println("NO CENTER provided");
            }

            int index_shape = 2+(fingerCount*2)+2;
            boolean first = true;
            PShape outline = createShape();
            outline.beginShape();
            while(index_shape < parts.length) {
              x = Float.parseFloat(parts[index_shape]);
              y = Float.parseFloat(parts[index_shape+1]);
              if(first) {
                first = false;
                outline.vertex(x, y);
              } else {
                outline.vertex(x, y);
              }
              index_shape += 2;
            }
            outline.stroke(10);
            outline.endShape();

            TokenTemplate tt = new TokenTemplate(points, tokenID, center);
            tt.setTokenOutline(outline);
            tokenTemplates.add(tt);
          }
          index+=1;
        }
        
  }

  public void addTemplate(TokenTemplate tt) {
    tokenTemplates.add(tt);
  }

  //public static void centerOnPoint(ArrayList<TouchPoint> points, TouchPoint refPoint) {
  //  for (TouchPoint pt : points) {
  //    pt.setLocation(pt.getX() - refPoint.getX(), pt.getY() - refPoint.getY());
  //  }
  //}

  //public static double angleBetweenVectors(TouchPoint vector1, TouchPoint vector2) {
  //  double angle = Math.atan2(vector2.getY(), vector2.getX()) - Math.atan2(vector1.getY(), vector1.getX());
  //  //  normalize to the range 0 .. 2 * Pi:
  //  if (angle < 0) angle += 2 * Math.PI;
  //  return angle;
  //}

  //public static void sortCCW(ArrayList<TouchPoint> points, final TouchPoint refPoint) {
  //  final TouchPoint vectorXAxis = new TouchPoint(10, 0);
  //  Collections.sort(points, new Comparator<TouchPoint>() {
  //    public int compare(TouchPoint pt1, TouchPoint pt2) {
  //      TouchPoint vector1 = new TouchPoint(pt1.getX() - refPoint.getX(), pt1.getY() - refPoint.getY());
  //      double angle1 = angleBetweenVectors(vectorXAxis, vector1);
  //      TouchPoint vector2 = new TouchPoint(pt2.getX() - refPoint.getX(), pt2.getY() - refPoint.getY());
  //      double angle2 = angleBetweenVectors(vectorXAxis, vector2);
  //      return (int)((angle2 - angle1)*100);
  //    }
  //  });
  //}

  //public static void rotateBy(ArrayList<TouchPoint> points, TouchPoint refPoint, double theta, ArrayList<TouchPoint> newPoints) {
  //  TouchPoint ptSrc, ptDest;
  //  for (int i = 0; i < points.size(); i++) {
  //    ptSrc = points.get(i);
  //    if (newPoints.size() > i) {
  //      ptDest = newPoints.get(i);
  //    } else {
  //      ptDest = new TouchPoint();
  //      newPoints.add(i, ptDest);
  //    }
  //    double x = (ptSrc.getX() - refPoint.getX()) * Math.cos(theta) - (ptSrc.getY() - refPoint.getY()) * Math.sin(theta) + refPoint.getX();
  //    double y = (ptSrc.getX() - refPoint.getX()) * Math.sin(theta) + (ptSrc.getY() - refPoint.getY()) * Math.cos(theta) + refPoint.getY();
  //    ptDest.setLocation(x, y);
  //  }
  //}

  //public static void rotateBy(TouchPoint point, TouchPoint refPoint, double theta, TouchPoint newPoint) {
  //  double x = (point.getX() - refPoint.getX()) * Math.cos(theta) - (point.getY() - refPoint.getY()) * Math.sin(theta) + refPoint.getX();
  //  double y = (point.getX() - refPoint.getX()) * Math.sin(theta) + (point.getY() - refPoint.getY()) * Math.cos(theta) + refPoint.getY();
  //  newPoint.setLocation(x, y);
  //}

  //public static double sortAndAlign(ArrayList<TouchPoint> points, TouchPoint refPoint, ArrayList<TouchPoint> resPoints) {
  //  resPoints.clear();
  //  for (TouchPoint pt : points) {
  //    resPoints.add(new TouchPoint(pt.getX(), pt.getY()));
  //  }
  //  centerOnPoint(resPoints, refPoint);
  //  TouchPoint origin = new TouchPoint(0, 0);
  //  sortCCW(resPoints, origin);
  //  TouchPoint refVector = new TouchPoint(resPoints.get(0).getX(), resPoints.get(0).getY());
  //  TouchPoint xAxisVector = new TouchPoint(10, 0);
  //  double angle = angleBetweenVectors(refVector, xAxisVector);
  //  rotateBy(resPoints, origin, angle, resPoints);
  //  return angle;
  //}

  //public static void sort(ArrayList<TouchPoint> points, TouchPoint refPoint, ArrayList<TouchPoint> resPoints) {
  //  resPoints.clear();
  //  for (TouchPoint pt : points) {
  //    resPoints.add(new TouchPoint(pt.getX(), pt.getY()));
  //  }
  //  centerOnPoint(resPoints, refPoint);
  //  TouchPoint origin = new TouchPoint(0, 0);
  //  sortCCW(resPoints, origin);
////    TouchPoint refVector = new TouchPoint(resPoints.get(0).getX(), resPoints.get(0).getY());
////    TouchPoint xAxisVector = new TouchPoint(10, 0);
////    double angle = angleBetweenVectors(refVector, xAxisVector);
////    rotateBy(resPoints, origin, angle, resPoints);
////    return angle;
  //}

  //public static double sortAndAlignTemplate(TokenTemplate template, TouchPoint refPoint) {
  //  centerOnPoint(template.getPoints(), refPoint);
  //  template.getCenter().setLocation(template.getCenter().getX() - refPoint.x, template.getCenter().getY() - refPoint.y);

  //  TouchPoint origin = new TouchPoint(0, 0);
  //  sortCCW(template.getPoints(), origin);
  //  TouchPoint refVector = new TouchPoint(template.getPoints().get(0).getX(), template.getPoints().get(0).getY());
  //  TouchPoint xAxisVector = new TouchPoint(10, 0);
  //  double angle = angleBetweenVectors(refVector, xAxisVector);
  //  rotateBy(template.getPoints(), origin, angle, template.getPoints());


  //  double x = template.getCenter().getX() * Math.cos(angle) - template.getCenter().getY() * Math.sin(angle);
  //  double y = template.getCenter().getX() * Math.sin(angle) + template.getCenter().getY() * Math.cos(angle);
  //  template.getCenter().setLocation(x, y);

  //  return angle;
  //}


  //public static void rotateTemplate(TokenTemplate template, double angle) {
  //  ArrayList<TouchPoint> resPoints = new ArrayList<TouchPoint>();
  //  for (TouchPoint pt : template.points) {
  //    resPoints.add(new TouchPoint(pt.getX(), pt.getY()));
  //  }
  //  TouchPoint origin = new TouchPoint(0, 0);
  //  rotateBy(resPoints, origin, angle, resPoints);
  //  TouchPoint resCenter = new TouchPoint(template.getCenter().x, template.getCenter().y);
  //  double x = resCenter.getX() * Math.cos(angle) - resCenter.getY() * Math.sin(angle);
  //  double y = resCenter.getX() * Math.sin(angle) + resCenter.getY() * Math.cos(angle);
  //  resCenter.setLocation(x, y);
  //  template.setPoints(resPoints);
  //  template.setCenter(resCenter);
  //}

  //public static void translateTemplate(TokenTemplate template, TouchPoint translate) {
  //  for (TouchPoint pt : template.points) {
  //    pt.setLocation(pt.x + translate.x, pt.y + translate.y);
  //  }
  //  template.getCenter().setLocation(template.getCenter().x + translate.x, template.getCenter().y+translate.y);
  //}

  //public static TouchPoint centroid(ArrayList<TouchPoint> points) {
  //  double sumX = 0;
  //  double sumY = 0;
  //  for (Iterator<TouchPoint> iterator = points.iterator(); iterator.hasNext();) {
  //    TouchPoint next = iterator.next();
  //    if(next != null) {
  //      sumX += next.getX();
  //      sumY += next.getY();
  //    }
  //  }
  //  int length = points.size();
  //  return new TouchPoint(sumX / length, sumY / length);
  //}

  //public static ArrayList<ArrayList<TouchPoint>> allPermutations(ArrayList<TouchPoint> points) {
  //  ArrayList<ArrayList<TouchPoint>> allPermutations = new ArrayList<ArrayList<TouchPoint>>();
  //  for (int i = 0; i < points.size(); i++) {
  //    ArrayList<TouchPoint> order = new ArrayList<TouchPoint>();
  //    order.add(points.get(i));
  //    for(int j = i+1; j < points.size(); j++) {
  //      order.add(points.get(j));
  //    }
  //    for(int j = 0; j < i; j++) {
  //      order.add(points.get(j));
  //    }
  //    allPermutations.add(order);
  //  }
  //  return allPermutations;
  //}

  //public static double meanSquaredPairedPointDistanceForAlignedPairs(ArrayList<TouchPoint> points1, ArrayList<TouchPoint> points2) {
  //  if(points1.size() != points2.size()) {
  //    return Double.MAX_VALUE;
  //  } else {
  //    double res = 0;
  //    for (int i = 0; i < points1.size(); i++) {
  //      TouchPoint p1 = points1.get(i);
  //      TouchPoint p2 = points2.get(i);
  //      res += (p1.getX() - p2.getX()) * (p1.getX() - p2.getX()) + (p1.getY() - p2.getY()) * (p1.getY() - p2.getY());
  //    }
  //    return res / points1.size();
  //  }
  //}

  //public static DistanceResult minDistance(TokenTemplate templateOrderedAndAligned, ArrayList<TouchPoint> inputPoints, TouchPoint refPoint) {
  //  ArrayList<TouchPoint> inputPointsOrderedAndAligned = new ArrayList<TouchPoint>();
////    double alignAngle = sortAndAlign(inputPoints, refPoint, inputPointsOrderedAndAligned);
  //  sort(inputPoints, refPoint, inputPointsOrderedAndAligned);

  //  ArrayList<ArrayList<TouchPoint>> allPermutations = allPermutations(inputPointsOrderedAndAligned);
  //  double minDis = Double.MAX_VALUE;
  //  double angleRotate = 0;
  //  for (ArrayList<TouchPoint> inputPermutation : allPermutations) {
  //    TouchPoint origin = new TouchPoint(0, 0);
  //    TouchPoint refVector = new TouchPoint(inputPermutation.get(0).getX(), inputPermutation.get(0).getY());
  //    TouchPoint xAxisVector = new TouchPoint(10, 0);
  //    double angle = angleBetweenVectors(refVector, xAxisVector);
  //    ArrayList<TouchPoint> inputPermutationRotated = new ArrayList<TouchPoint>();
  //    rotateBy(inputPermutation, origin, angle, inputPermutationRotated);
  //    double d = meanSquaredPairedPointDistanceForAlignedPairs(inputPermutationRotated, templateOrderedAndAligned.getPoints());
  //    if(d < minDis) {
  //      minDis = d;
  //      angleRotate = angle;
  //    }
  //  }

  //  // modify the template to align it with input
////    rotateTemplate(templateOrderedAndAligned, -(angleRotate+alignAngle));
  //  rotateTemplate(templateOrderedAndAligned, -(angleRotate));
  //  translateTemplate(templateOrderedAndAligned, new TouchPoint(refPoint.x, refPoint.y));

  //  return new DistanceResult(angleRotate, minDis);
  //}

  //public TokenTemplate recognize(ArrayList<TouchPoint> input) {
  //  if(input.size() != 3) {
  //    return null;
  //  }
  //  for (TokenTemplate tokenTemplate : tokenTemplates) {
  //    tokenTemplate.setRecognitionDistance(Double.MAX_VALUE);
  //  }
  //  double minDis = Double.MAX_VALUE;
  //  TokenTemplate tokenRecognized = null;
  //  for (TokenTemplate tokenTemplate : tokenTemplates) {

  //    ArrayList<TouchPoint> points = new ArrayList<TouchPoint>();
  //    for (TouchPoint touchPoint : tokenTemplate.getPoints()) {
  //      points.add(new TouchPoint(touchPoint.x, touchPoint.y));
  //    }
  //    TouchPoint center = new TouchPoint(tokenTemplate.getCenter().x, tokenTemplate.getCenter().y);
  //    TokenTemplate templateTransformed = new TokenTemplate(points, tokenTemplate.getTokenID(), center);
  //    templateTransformed.setOriginalGeometryTemplate(templateTransformed);
  //    double templateAngle = sortAndAlignTemplate(templateTransformed, centroid(tokenTemplate.getPoints()));
////      double d = minDistance(templateTransformed, input, centroid(input));
////      templateTransformed.setDistance(d);
  //    DistanceResult inputDistance = minDistance(templateTransformed, input, centroid(input));
  //    templateTransformed.setRecognitionDistance(inputDistance.getDistance());
////      System.out.println("\t"+tokenTemplate.tokenID+" _ template:"+templateAngle+" _ input:"+inputDistance.getAngle());
  //    templateTransformed.setOrientation(inputDistance.getAngle()-templateAngle);
////      templateTransformed.setAngle(dr.getAngle());

  //    if(inputDistance.getDistance() < minDis) {
  //      minDis = inputDistance.getDistance();
  //      tokenRecognized = templateTransformed;
  //    }
  //  }

  //  if(tokenRecognized == null) {
  //    return null;
  //  }

  //  // sort template points
  //  ArrayList<TouchPoint> unsortedTemplatePoints = new ArrayList<TouchPoint>();
  //  unsortedTemplatePoints.addAll(tokenRecognized.getPoints());
  //  ArrayList<TouchPoint> sortedTemplatePoints = new ArrayList<TouchPoint>();
  //  for(int i = 0; i < input.size(); i++) {
  //    double minDistance = Double.MAX_VALUE;
  //    int indexMinDistance = -1;
  //    for(int j = 0; j < unsortedTemplatePoints.size(); j++) {
  //      double d = input.get(i).distance(unsortedTemplatePoints.get(j));
  //      if(d < minDistance) {
  //        minDistance = d;
  //        indexMinDistance = j;
  //      }
  //    }
  //    TouchPoint point = unsortedTemplatePoints.remove(indexMinDistance);
  //    sortedTemplatePoints.add(point);
  //  }
  //  tokenRecognized.setPoints(sortedTemplatePoints);

  //  return tokenRecognized;
  //}

  ////public static void main(String[] args) {
  ////  new TouchTokenRecognizer(new File("templates.txt"));
  ////}

  //public ArrayList<TokenTemplate> getTokenTemplates() {
  //  return tokenTemplates;
  //}

  //public void setTokenTemplates(ArrayList<TokenTemplate> tokenTemplates) {
  //  this.tokenTemplates = tokenTemplates;
  //}

  //public TokenTemplate getTemplate(String tokenID) {
  //  for (TokenTemplate tokenTemplate : tokenTemplates) {
  //    if(tokenTemplate.getTokenID().compareTo(tokenID) == 0) {
  //      return tokenTemplate;
  //    }
  //  }
  //  return null;
  //}

}
//