import processing.opengl.*;

TimedLSystem lsys;
Turtle turtle;
float t;
float maxTime = 6;
boolean flag = false;

void setup() {
  size(640, 480, OPENGL);
  //smooth();
  
  lsys = new TimedLSystem();
  t = 0;
  
  // Algae system
//  lsys.setAxiom("r0");
//  lsys.addRule('r', 2, "l1;r0");
//  lsys.addRule('l', 2, "l0;r1");
  
  // 2D tree structure
//  float angle = radians(30);
//  lsys.setAxiom("A0");
//  lsys.addRule('A', 1, "F0;[;+;A0;];F0;A0");
//  lsys.addRule('A', 1, "F0;[;-;A0;];F0;A0");
    
  // branching structure
//  lsys.setAxiom("F0");
//  lsys.addRule('F', 1, "G;+;F0", 1);
//  lsys.addRule('F', 1, "G;-;F0", 1);
//  lsys.addRule('F', 1, "G;[;+;F0;];-;F0", 1);
//  float angle = radians(60);

//  parseSequence("Fa2[B]b[B]bF3.4c[B]aF");

  // 3D tree
  float angle = radians(30);
  lsys.setAxiom("FB");
  lsys.addRule('B', 1, "Fa[B]b[B]cFb[B]aF");
  lsys.addRule('B', 1, "Fb[B]c[B]aFb[B]cF");
  lsys.addRule('B', 1, "Fc[B]a[B]bFc[B]aF");
  lsys.addRule('a', 0, "-F");
  lsys.addRule('a', 0, "+F");
  lsys.addRule('a', 0, "&F");
  lsys.addRule('a', 0, "^F");
  lsys.addRule('b', 0, "////-F");
  lsys.addRule('b', 0, "////+F");
  lsys.addRule('b', 0, "////^F");
  lsys.addRule('b', 0, "////&F");
  lsys.addRule('c', 0, "\\\\\\\\-F");
  lsys.addRule('c', 0, "\\\\\\\\+F");
  lsys.addRule('c', 0, "\\\\\\\\&F");
  lsys.addRule('c', 0, "\\\\\\\\^F");
  turtle = new Turtle(lsys.getSentence(), 3, angle + random(-angle/2, angle/4), 1);
  
  //println("Starting: " + lsys.toString() );
}

void draw() {
    
  float delta = 1.0/60.0;
  t += delta;
  
  if ( t < maxTime )
  {
    lsys.generate(delta);
    turtle.setToDo(lsys.getSentence());
  } else if ( !flag ) {
    //println("Length of sentence: " + lsys.getSentence().size());
    flag = true;
  }
  background(255);
  
  pushMatrix();
      
  float rspeed = t < maxTime ? 0 : 2.0;
  //float t2 = t - maxTime;
  float t2 = (float)mouseX / width * 2 * PI;
  float d = 300;
  //float x = (float)mouseX/width - 0.5;
  camera( d*sin(t2), height * 0.2, d*cos(t2),
          0, height * 0.2, 0, 
          0, 1.0, 0);
          
  translate(0, height/2, 0);
  rotate(-PI/2);
  
  fill(0);
  stroke(0);
  
  //smooth(8);
  turtle.render();
  popMatrix();
  
  //saveFrame("frames/####.tif");
}

void mousePressed() {
  t = 0;
  float angle = radians(30);
  lsys.setAxiom("FB");
  turtle = new Turtle(lsys.getSentence(), 3, angle + random(-angle/2, angle/4), 1);
}
