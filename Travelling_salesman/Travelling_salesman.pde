
ArrayList<City> cities;
int cityAmount = 500;
Population population;

void setup(){
  fullScreen();
  //size(640,480);
  cities = new ArrayList<City>();
  for(int i = 0 ; i < cityAmount ; i++)
    cities.add(new City(random(20,width-20),random(20,height-20),i));
  population = new Population();
}


void draw(){
  background(255);
  population.update();
  
  for(City c:cities)
    c.display();
  
  //delay(10);
}