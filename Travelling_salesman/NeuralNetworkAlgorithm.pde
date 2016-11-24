/*
class NeuralNetworkAlgorithm{
 
  float distanceCityWeight;
  float distanceMiddleWeight;
  float weightVariance = 0.1;
  
  int generationCount = 0;
  float fitness = 0;
  int agentAmount = 225;
  int bestAgentAmount = 15;
  ArrayList<Agent> agents = new ArrayList<Agent>();
  String bestAgentFitness;
//constructor
  NeuralNetworkAlgorithm(){
    distanceMiddleWeight = random(-1,1);
    distanceCityWeight = random(0,1);
    for(int i = 0 ; i < agentAmount ; i++)
      agents.add(new Agent());
  }
  
  void update(){
    
    buildPaths();
    evaluation();
    ajustWeight();
    bestAgentFitness = nfc(agents.get(0).fitness,2);
    generationCount++;
  }
  
  void buildPaths(){
    Integer firstCityIndex = firstCityNeuralNetwork();//tout les agent vont commencer avec la meme ville soit la plus proche ou la plus loin
    
    for(Agent a :agents){
      ArrayList<Integer> path = new ArrayList<Integer>();
      //ajout de la premiere ville
      path.add(firstCityIndex);
      //Modification du weight pour l agent
      a.distanceMiddleWeight = distanceMiddleWeight + random(-weightVariance,weightVariance);
      a.distanceCityWeight = distanceCityWeight + random(-weightVariance,weightVariance);
      
      //on rajoute les cityAmount-1 ville restance
      City currentCity = cities.get(firstCityIndex);
      ArrayList<City> citiesLeft = (ArrayList<City>) cities.clone();
      citiesLeft.remove(cities.get(firstCityIndex));
      Integer cityIndex;
      for(int i = 1 ; i < cityAmount ; i++){
        cityIndex = cityNeuralNetwork(citiesLeft,currentCity,a);
        path.add(cityIndex);
        currentCity = cities.get(cityIndex);
      }

      a.setPath(path);
    }
  }
  
  
  //since its the first city we will apply only distanceMiddleWeight to the first city chosen
  Integer firstCityNeuralNetwork(){
    Integer bestCityIndex = 0;
    float bestDistance = 9999999;
    //la meilleur ville sera la plus proche
    if(distanceMiddleWeight > 0){
      for(City c :cities){
        if(c.distanceFromMiddle < bestDistance){
          bestDistance = c.distanceFromMiddle;
          bestCityIndex = c.index;
        }
      }
    }
    else
    {
      bestDistance = 0;
      for(City c :cities){
        if(c.distanceFromMiddle > bestDistance){
          bestDistance = c.distanceFromMiddle;
          bestCityIndex = c.index;
        }
      }
    }
    return bestCityIndex;
  }
  
  //pour chaque citiesleft on va compter sa valeur avec les poids et la currentCity et on va renvoyer l index de la meilleur
  Integer cityNeuralNetwork(ArrayList<City> citiesLeft , City currentCity , Agent a){
    
    Integer bestCityIndex = 0;
    float bestScore = 99999999;
    float score = 0;
    //la meilleur ville sera la plus proche
    
    for(City c :citiesLeft){
      score = 0;
      score += a.distanceMiddleWeight * c.distanceFromMiddle;
      score += a.distanceCityWeight * PVector.dist(currentCity.location,c.location);
      if(score < bestScore){
        bestScore = score;
        bestCityIndex = c.index;
      }
    }
    //we remove the city of the citiesLeft
    for(int i = 0 ; i < citiesLeft.size();i++){
      if(citiesLeft.get(i).index == bestCityIndex){
        citiesLeft.remove(i);
        break;
      }
    }
    return bestCityIndex;
    
  }
  void evaluation(){
 
    float fitness = 0;

    for(Agent a:agents){
      for(int i = 0 ; i < cityAmount-1 ; i++)
        fitness += PVector.dist(cities.get(a.path.get(i)).location , cities.get(a.path.get(i+1)).location);
      a.fitness = fitness;
      fitness = 0;
    }
    
    java.util.Collections.sort(agents);
    
  }
  
  
  void ajustWeight(){
    float sumMW = 0;
    float sumCW = 0;
    for(int i = 0 ; i < bestAgentAmount;i++){
      sumMW += agents.get(i).distanceMiddleWeight; 
      sumCW += agents.get(i).distanceCityWeight; 
    }
   distanceMiddleWeight = sumMW / bestAgentAmount;
   distanceCityWeight = sumCW / bestAgentAmount;
  }
  
   void display(){
    
    drawBest();
    drawGenerationInfo();
  }
  void drawBest(){
   
    for(int i = 0 ; i < cityAmount-1 ; i++){
      stroke(color(random(255),random(255),random(255)));
      line(cities.get(agents.get(0).path.get(i) ).location.x, cities.get(agents.get(0).path.get(i) ).location.y,
           cities.get(agents.get(0).path.get(i+1) ).location.x, cities.get(agents.get(0).path.get(i+1) ).location.y);
    }
           
    noFill();
    stroke(#e50404);
    ellipse(cities.get(agents.get(0).path.get(0) ).location.x, cities.get(agents.get(0).path.get(0) ).location.y,20,20);
    stroke(#111111);
    ellipse(cities.get(agents.get(0).path.get(cityAmount-1) ).location.x, cities.get(agents.get(0).path.get(cityAmount-1) ).location.y,20,20);
  
  }

  
  void drawGenerationInfo(){

    text("generation count: " +generationCount,20,10);
    text("bestScore: " + bestAgentFitness,300,10);
    text("bestAgentdistanceCityWeight : " + agents.get(0).distanceCityWeight,20,20);
    text("bestAgentdistanceMiddleWeight" + agents.get(0).distanceMiddleWeight,300,20);
  }
}*/