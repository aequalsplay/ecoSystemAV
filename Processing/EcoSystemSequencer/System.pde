ArrayList<Boid> boids;

ArrayList<Food> food;
DNA dna;



class System {

 
  PVector objPos = new PVector(width/2, height/2);
  
  System(int numBoids, int numFood) {
    
    // Set up arrays for Boids and Food, add one Object
    boids = new ArrayList<Boid>();
    food = new ArrayList<Food>();
   
    
    // Set up DNA instance
    DNA dna = new DNA();    
    
    // Create 'num' number of Boids at random positions
    for(int i = 0; i < numBoids; i++) {
      PVector pos = new PVector(random(width), random(height)); 
      boids.add(new Boid(pos, dna));  
    }
    // Create 'num' number of Food at random positions
    for(int j = 0; j < numFood ; j++) {
      PVector foodPos = new PVector(random(width), random(height));
      food.add(new Food(foodPos));  
    }
   
  }
  
  // Method to run food
   void runFood(){
     // Iterate backwards through Food array, get each element and display
       for(int i = food.size()-1; i >= 0; i--){  
         Food f = food.get(i);
         f.display();    
      }
      
      // Create new food is there is none
      if(food.size() >= 0){
           addFood(10);
         }
    }
    
   
    
  // Method to run Boids
  void runBoids() {

    // Iterate backwards through Boids array, get each element 
    for(int i = boids.size()-1; i >= 0; i--){  
     Boid b = boids.get(i);
    
     // If Boid radius is great or eqaual to 60, run the reproduce function
       if (b.r >= 60) {
        Boid child = b.reproduce();
        // If reproduce returns a child, add new Boid
        if (child != null) boids.add(child);
        }
        
     // If Boids array size is greater than 20, remove first element in array 
     if (boids.size() > 20) {
      boids.remove(1); 
     }
      // If Boid dies, remove & add food
     if (b.dead()) {
        boids.remove(i);
        food.add(new Food(b.pos));
      } 
      // Otherwise run Boids as normal:
      else {
           
           b.seekFood(food, 2);
           b.boundaries(4);
           b.borders();  
           b.avoidBoids(/* Array: */ boids, /* Strength of force: */ 2);
           b.wander();
           b.display();  
           b.update();
      }
    }
  }
    
  
    
    
  // Add food method
  void addFood(int num) {
    // If new food on screen, add more 
    if(food.size() == 0) { 
          for(int i = 0; i < num; i++) {
            PVector rand = new PVector(random(width), random(height));
        food.add(new Food(rand));
      } 
    }
  }

  // Returns the Food array when called
   ArrayList getFood() {
      return food; 
    }
}
