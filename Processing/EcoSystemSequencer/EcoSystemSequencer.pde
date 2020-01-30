System s;
Boid b;

void setup() {

  fullScreen(P2D, 1);
  //size(640, 320, P2D);
  s = new System(2, 30);
}

void draw() {
  background(0);
   s.runFood();
   s.runBoids();


  //println(frameRate);
}
