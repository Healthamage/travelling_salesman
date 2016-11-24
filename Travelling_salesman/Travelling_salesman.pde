//time management variables
enum Algorithm{GENETIC,ANTCOLONY,NEURALNETWORK}
long previousTime = 0;
long currentTime = 0;
long deltaTime;
long displayAcc = 0;
long displayDelay = 500;
long updateAcc = 0;
long updateDelay = 500;

ArrayList<City> cities;
int cityAmount = 20;

GeneticAlgorithm geneticAlgorithm;
AntColony antColony;
//NeuralNetworkAlgorithm neuralNetWorkAlgorithm;

Algorithm algorithm;
void setup(){
  fullScreen();
  //size(640,480);
  cities = new ArrayList<City>();
  for(int i = 0 ; i < cityAmount ; i++)
    cities.add(new City(random(20,width-20),random(20,height-20),i));
  
  geneticAlgorithm = new GeneticAlgorithm();
  antColony = new AntColony();
  //neuralNetWorkAlgorithm = new NeuralNetworkAlgorithm();
  algorithm  = Algorithm.GENETIC;
}


void draw(){
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime; 
  
  updateAcc += deltaTime;
  if(updateAcc > updateDelay){
    updateAcc = 0 ;
    //neuralNetWorkAlgorithm.update();
    geneticAlgorithm.update();
    antColony.update();
  }
  displayAcc += deltaTime;
  if(displayAcc > displayDelay){
    displayAcc = 0 ;
    display();
  }

  
}

void display(){
  
  background(255);
  switch(algorithm){
    case GENETIC:
      geneticAlgorithm.display();
      break;
    case ANTCOLONY:
      antColony.display();
      break;
    case NEURALNETWORK:
      //neuralNetWorkAlgorithm.display();
      break;
  }

  for(City c:cities)
    c.display();
}

void keyPressed(){
  
  switch(key){
    case 'a':
      algorithm = Algorithm.ANTCOLONY;
      break;
    case 'g':
      algorithm = Algorithm.GENETIC;
      break;
    case 'n':
      algorithm = Algorithm.NEURALNETWORK;
      break;
    case 't':
      antColony.showPheromones = !antColony.showPheromones;
    default:
      break;
  }
}