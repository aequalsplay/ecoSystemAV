



class Boid {
  
  // // // // // // // // // // // // // // // // // 
  // Global class variables
  // // // // // // // // // // // // // // // // // 
  
  PVector pos = new PVector(random(width), random(height));
  PVector vel;
  PVector acc;  
  float xoff;       
  float yoff;
  float r;
  float mass;
  float maxforce;  
  float maxspeed;
  float life;
  float hue;
  float sat;
  
  float wandertheta;
  float count;
  
  String oscAddr;
  
  float boidPosX;
  float boidPosY;
  float boidVel;
  float boidR;
 

Object obj;
  DNA dna;
  
  // // // // // // // // // // // // // // // // // 
  // Constructor function
  // // // // // // // // // // // // // // // // //   
  
  Boid (PVector position, DNA dna_) {   
     pos = position.copy();
     acc = new PVector(0, 0);
     vel = new PVector(0, 0);
     dna = dna_;    
     wandertheta = 0;

     // Set colours (map from DNA) 
     hue = map(dna.genes[0], 0, 1, 0, 360);
     sat = map(dna.genes[1], 0, 1, 80, 100); 
     
     println(dna.genes[1]);
     // Set initial life, radius, and mass
     life = 100;
     r = life/2; 
     mass = r * 4;
     
     // Set max speed and max force
     maxspeed = 2;
     maxforce = 0.7;
     
     // Initialise Food array and Object
     food = new ArrayList<Food>();
     
      
    // Set Color Mode
      colorMode(HSB, 360, 100, 100);
       
  }

     
  // // // // // // // // // // // // // // // // // 
  // Update Boids
  // // // // // // // // // // // // // // // // // 
  
  void update() {
    
    // Physics engine for steering
    vel.add(acc);
    vel.limit(maxspeed);
    pos.add(vel);
    acc.mult(0);
    
    // Health decreases every frame
    life -= 0.2; 
 
    // OSC Messages
     boidPosX = map((pos.x), 0, width, 10, 500);
     boidPosY = map((pos.y), 0, height, 10, 500);
     boidVel = map((vel.y), 0, 1, 10, 20);
     boidR = map((r), 0, 60, 10, 500);

   
  }
    
   
     
    // Dead?
    boolean dead() {
      if (life <= 0) {
        return true;
      }
      else {
        return false;
      }
    }
  
     // This reproduce method gets called in the 'System' Class, on line 77
     // Only gets called when 'r' (radius) >= 60
    Boid reproduce() {
      // Probability of repdoucing
      if (random(1) < 0.0009) {
   
        // Sets both Boids back to radius of 20
        life = 100;   
        r = life / 2;
        // childDNA is exact copy of parent
        DNA childDNA = dna.copy();
        // Mutate childDNA
        childDNA.mutate(0.5);
        // Create child boid
        return new Boid(pos, childDNA); 
      } 
     else {
      return null;
    }
    }
      
  
  // // // // // // // // // // // // // // // // // 
  // Display Boids
  // // // // // // // // // // // // // // // // // 
  
  void display() {
     pushMatrix();
    
     push();
     float theta = vel.heading() + radians(90);
     
       fill(hue, sat, life);
       stroke(hue, sat, life+100);
       strokeWeight(8);
       translate(pos.x, pos.y);
       rotate(theta);
       //beginShape(POLYGON);
        //vertex(0, -r);
        //vertex(-r, r*2);
        //vertex(r, r*2);
        //scale(1);
       //endShape(CLOSE);
       ellipse(0, 0, r, r );
       popMatrix();
       pop();
  }
  
  // // // // // // // // // // // // // // // // // 
  // Steering Behaviours
  // // // // // // // // // // // // // // // // // 
   
  // Apply force function
  void applyForce(PVector force){ 
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

 
  
  // Avoid other Boids
  void avoidBoids(ArrayList<Boid> boids, float mult){
  float desiredSeparation = r+100;
  PVector sum = new PVector();
  int count = 0;
  for(Boid b : boids) {
   float d = PVector.dist(pos, b.pos);
   if((d > 0) && (d < desiredSeparation)) {
     PVector diff = PVector.sub(pos, b.pos);
     diff.normalize();
     diff.div(d);
     sum.add(diff);
     count++;
   }
  }
  if( count > 0) {
   sum.setMag(maxspeed);
   PVector avoidBoids = PVector.sub(sum, vel);
   avoidBoids.mult(mult);
   applyForce(avoidBoids);  
  }
 }
  
  // Seek food
    void seekFood(ArrayList<Food> food, float mult){
  float desiredSeparation = r+400;
  PVector sum = new PVector();
  int count = 0;
  for(int i = food.size()-1; i >= 0; i--) {
   Food f = food.get(i);
   float d = PVector.dist(pos, f.pos);
     if (d < r) {
        life += 100; 
        r += 3;
        food.remove(f);
      }
   if((d > 0) && (d < desiredSeparation)) {
     PVector diff = PVector.sub(f.pos, pos);
     diff.normalize();
     diff.div(d);
     sum.add(diff);
     count++;
   } else if (d < 6) {
    acc.mult(0); 
   }
      
  if( count > 0) {
   sum.setMag(maxspeed);
   PVector seekFood = PVector.sub(sum, vel);
   seekFood.mult(mult);
   applyForce(seekFood);
    }
  }
 }
   
  // // // // // // // // // // // // // // // // // 
  // Set boundaries
  // // // // // // // // // // // // // // // // // 
  
   // Boundaries
  void boundaries(float mult ) {

    float d = 180;
    PVector boundary = new PVector(0, 0);

    if (pos.x < d) {
        boundary.x = 1;
    } else if (pos.x > width -d) {
        boundary.x = -1;
    } 
    
    if (pos.y < d) {
        boundary.y = 1;
    } else if (pos.y > height-d) {
        boundary.y = -1;
    } 

    boundary.setMag(mult);
    applyForce(boundary);
  }
  
   // Stop at edges
  void borders() {
    if (pos.x < r/2) pos.x = 0 + r/2;
    if (pos.y < r/2) pos.y = 0 + r/2;
    if (pos.x > width - r/2) pos.x = width - r/2;
    if (pos.y > height - r/2) pos.y = height - r/2;
  }
   
   // Wander around
   void wander() {
    float wanderR = 25;         // Radius for our "wander circle"
    float wanderD = 80;         // Distance for our "wander circle"
    float change = 0.9;
    wandertheta += random(-change,change);     // Randomly change wander theta

    // Now we have to calculate the new position to steer towards on the wander circle
    PVector circlepos = vel.copy();    // Start with velocity
    circlepos.normalize();            // Normalize to get heading
    circlepos.mult(wanderD);          // Multiply by distance
    circlepos.add(pos);               // Make it relative to boid's position

    float h = vel.heading();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h),wanderR*sin(wandertheta+h));
    PVector target = PVector.add(circlepos,circleOffSet);
    seek(target);
 // Render wandering circle, etc.
    drawWanderCircle(pos,circlepos,target,wanderR);
    
  }
    // Generic seek function
   void seek(PVector target) {
    PVector desired = PVector.sub(target,pos);  // A vector pointing from the position to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,vel);
    
    steer.limit(maxforce);  // Limit to maximum steering force
    steer.mult(4);
    applyForce(steer);
  }
  
   // OSC STUFF  
    void osc(){


    //println(oscStuff);
     





   
    }
    
    void oscBorn() {



    }
  
  
  
    // Draw wandering circle
    void drawWanderCircle(PVector position, PVector circle, PVector target, float rad) {
      stroke(255, 200);
      noFill();
      ellipseMode(CENTER);
      ellipse(circle.x,circle.y,rad*2,rad*2);
      ellipse(target.x,target.y,4,4);
      line(position.x,position.y,circle.x,circle.y);
      line(circle.x,circle.y,target.x,target.y);
    }
    

}
