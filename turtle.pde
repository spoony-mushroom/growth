//import java.util.Stack;

class Turtle {
  ArrayList<TimedLetter> todo;  // command string
  float len;    // length of line
  float theta;  // angle of turn
  int baseWeight;
  float deviation;
  
  Turtle(ArrayList<TimedLetter> s, float l, float t, int w) {
    todo = s;
    len = l;
    theta = t;
    baseWeight = w;
    deviation = 0;
  }
  
  void setAngleDeviation(float d) {
    deviation = d;
  }
  
  void render() {
    //Stack<Integer> weightStack = new Stack<Integer>();
    int weight = baseWeight;
    //strokeWeight( 4 );
    float turnAngle = theta;
    for (TimedLetter l : todo) {
      float drawLen = len * l.age;
      //strokeWeight(max(weight * l.age, 1.0));
      //println("letter is " + byte(l.letter));
      //byte c = byte(l.letter);
      switch(l.letter) {
        case (int)'F':
        case (int)'G':
            // Forward line
            line(0, 0, 0, drawLen, 0, 0);
        case (int)'f':
            // Move forward without drawing
            translate(drawLen, 0, 0);
            break;
        case (int)'+':
            // turn left
            rotateZ(turnAngle);
            break;
        case (int)'-':        
            // turn right
            rotateZ(-turnAngle);
            break;
        case (int)'&':
            // pitch up
            rotateY(turnAngle);
            break;
        case (int)'^':
            // pitch down
            rotateY(-turnAngle);
            break;
        case (int)'\\':
            // roll left
            rotateX(turnAngle);
            break;
        case (int)'/':
            // roll right
            rotateX(-turnAngle);
            break;
        case (int)'|':
            // turn 180
            rotateZ(PI);
            break;            
        case (int)'[':
            pushMatrix();
            break;
        case (int)']':
            popMatrix();
            break;
      }
      /*
      if (l.letter.equals("f")) {
        // Move forward without drawing
          translate(drawLen, 0, 0);
      } else if (l.letter.equals("+")) {
          // turn left
          //println("turn left");
          rotateZ(turnAngle);
      } else if (l.letter.equals("-")) {        
          // turn right
          rotateZ(-turnAngle);
      } else if (l.letter.equals("&")) {
          // pitch up
          rotateY(turnAngle);
      } else if (l.letter.equals("^")) {
          // pitch down
          rotateY(-turnAngle);
      } else if (l.letter.equals("\\")) {
          // roll left
          rotateX(turnAngle);
      } else if (l.letter.equals("/")) {
          // roll right
          rotateX(-turnAngle);
      } else if (l.letter.equals("|")) {
          // turn 180
          rotateZ(PI);
      } else if (l.letter.equals("[")) {
          // save current position/rotation/weight
          //weightStack.push(weight);
          pushMatrix();
      } else if (l.letter.equals("]")) {
          // go to last saved position/weight
          //weight = weightStack.pop();
          popMatrix();
      } else if (l.letter.equals("!")) {
          weight--;
      } else if (l.letter.equals("`")) {
          //weight++;
      } else if (l.letter.equals("F") || l.letter.equals("G")) {
          // Forward line
          line(0, 0, 0, drawLen, 0, 0);
          translate(drawLen, 0, 0);
          //println("draw forward");
      }
      */
    }
  }
  
  void setLen(float l) {
    len = l;
  }
  
  void scaleLen(float percent) {
    len *= percent;
  }
  
  void setToDo(ArrayList<TimedLetter> s) {
    todo = s;
  }
}
