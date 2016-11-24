class City{

  PVector location;
  int index;
  
  
  City(float x , float y,int index){
    location = new PVector(x,y);
    this.index = index;
  }
  
  void display(){
    
    noStroke();
    fill(0);
    ellipse(location.x,location.y,10,10);
  }
}