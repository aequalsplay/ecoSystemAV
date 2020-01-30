class DNA {
 
  float[] genes;
  
 DNA() {
   genes = new float[4];
   for(int i = 0; i < genes.length; i++) {
      genes[i] = random(1); 
      
   }
 }
 
 DNA(float[] newgenes) {
  genes = newgenes; 
  
 }
 
 DNA copy() {
  float[] newgenes = new float[genes.length];
  
  for(int i = 0; i < newgenes.length; i++) {
   newgenes[i] = genes[i]; 

  }
  
  return new DNA(newgenes);
 }
 
  
  void mutate(float m) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < m) {
         genes[i] = random(0,1);
      }
    }
  }
 
}
