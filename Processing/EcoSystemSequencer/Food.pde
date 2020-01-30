class Food {
  
  PVector pos;  
  float r;  
 
 
  Food(PVector foodPos){
     r = 10; 
     pos = foodPos.copy();
  }
  
  // Add some food at a position
  
    
  void display() {  
    rectMode(CENTER);
    stroke(0);
    fill(255); 
    rect(pos.x,pos.y,r,r);  
    
  
  }
 
 
 
}
