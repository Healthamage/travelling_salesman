class AntColony{
  
  GenerationInfo generationInfo = new GenerationInfo();
  int antAmount = 100;
  ArrayList<Ant> ants = new ArrayList<Ant>();
  int [][] pheromones;
  int [] startingPointPheromones = new int[cityAmount];
  ArrayList<AntCityIndex> antCities = new ArrayList<AntCityIndex>();
  boolean showPheromones = false;
  int cumulativeWeight;
//constructor
  AntColony(){
    cumulativeWeight = calculCumulativeWeight();
    for(int i = 0 ; i < antAmount ; i++)
      ants.add(new Ant());
  }
  
  void update(){
    
    evaluation();
    regeneration();
    calculHomogenity();
    generationInfo.generationCount++;
  }
  
  void display(){
    if(!showPheromones){
      drawBest();
      drawGenerationInfo();
    }
    else{
      drawPheromones();
    }
  }
  
  void evaluation(){

    for(Ant a:ants)
      a.calculFitness();
    java.util.Collections.sort(ants);
    
    generationInfo.bestFitness = ants.get(0).fitness;
    generationInfo.bestPath = (ArrayList<Integer>)ants.get(0).path.clone();
    float totalFitness = 0;
    for(Ant a:ants)
      totalFitness += a.fitness;
    generationInfo.gain = generationInfo.averageFitness - totalFitness / antAmount;
    generationInfo.averageFitness = totalFitness / antAmount;
    
  }
  
  
  
  void regeneration(){
    //regenerate the next generation with random depending of the pheromone
    //of the previous generation
    
    //fill pheromones tab since the ants are ordered the weight will go lower for each ant
    //pheromones[from][to]
    pheromones = new int[cityAmount][cityAmount];
    int weight = antAmount;
    for(Ant a :ants){
      startingPointPheromones[a.path.get(0)] += weight;
      for(int i = 0 ; i < cityAmount - 1 ; i++)  
        pheromones[a.path.get(i)][a.path.get(i+1)] += weight;
      weight--;
    }
    
    ants.clear();
    //we generate antAmount path from pheromones weight and create ants from them
    for(int i = 0 ; i < antAmount ; i++){
      regenerateAntCities();
      ArrayList<Integer> path = new ArrayList<Integer>();
      addFirstCity(path);
      for(int j = 1 ; j < cityAmount ; j++)
        addCity(path);
      ants.add(new Ant(path));
    }
      
  }
  
  void regenerateAntCities(){
    antCities.clear();
    for(int i = 0 ; i < antAmount ; i++)
      antCities.add(new AntCityIndex(i,true));
  }
  void addFirstCity(ArrayList<Integer> path ){
    
    int index = 0;
    float weightValue = random(0,cumulativeWeight);
    float currentWeight = 0;
    for(int i = 0 ; i < startingPointPheromones.length ; i++){
      currentWeight += startingPointPheromones[i];
      if(currentWeight >= weightValue){
        index = i;
        break;
      }
    }
      
    path.add((Integer)index);
    antCities.get(index).available = false;
 
  }
  
  void addCity(ArrayList<Integer> path){
    
    int index = 0;
    int totalWeight = 0;
    //calcul the totalWeight of all city of the current city
    for(int i = 0 ; i < cityAmount ; i++)
      if(antCities.get(i).available)
        totalWeight += pheromones[path.get(path.size()-1)][i];
    //get a random number of this total weight and associate the correct id to it
    float weightValue = random(0,totalWeight);
    float currentWeight = 0;
    for(int i = 0 ; i < cityAmount ; i++)
      if(antCities.get(i).available){
        currentWeight += pheromones[path.get(path.size()-1)][i];
        if(currentWeight >= weightValue){
          index = i;
          break;
        }
      }
       
        
    path.add((Integer)index);
    antCities.get(index).available = false;
  }
  
  
  void drawBest(){

      for(int i = 0 ; i < cityAmount-1 ; i++){
        stroke(color(200,0,0,50));
        strokeWeight(3);
        line(cities.get(generationInfo.bestPath.get(i) ).location.x, cities.get(generationInfo.bestPath.get(i) ).location.y,
             cities.get(generationInfo.bestPath.get(i+1) ).location.x, cities.get(generationInfo.bestPath.get(i+1) ).location.y);
      }
           
      noFill();
      stroke(#e50404);
      strokeWeight(10);
      ellipse(cities.get(generationInfo.bestPath.get(0) ).location.x, cities.get(generationInfo.bestPath.get(0) ).location.y,20,20);
      stroke(#00ffff);      
      ellipse(cities.get(generationInfo.bestPath.get(cityAmount-1) ).location.x, cities.get(generationInfo.bestPath.get(cityAmount-1) ).location.y,20,20);
      
  }
  
  void drawGenerationInfo(){
    text("AntColony Algorithm " ,20,10);
    text("generation count: " + generationInfo.generationCount,20,20);
    text("bestFitness: " + generationInfo.bestFitness,200,10);
    text("averageFitness: " + generationInfo.averageFitness,200,20);
    text("generation gain: " + generationInfo.gain,400,10);
    text("generation homogenity: " + nfc(generationInfo.homogenity,2) + "%" ,400,20);
  }
  
  void drawPheromones(){
    //different color depending 
    //#ea0909 red 80% ++
    //#0914ea blue 60++%
    //#1cea09 green 40++%
    //#fffb1e yellow 20++%
    //#ff1ee4 10%++
    
   color c = 0;
   strokeWeight(2);
   for(int i = 0 ; i < cityAmount ; i++){
     for(int j = 0 ; j < cityAmount ; j++){
       float ratio = (float)pheromones[i][j] / cumulativeWeight;
       if(ratio > 0.10){
         if(ratio < 0.20)
           c = #ff1ee4;
         else if(ratio < 0.40)
           c = #fffb1e;
         else if(ratio < 0.60)
           c = #1cea09;
         else if(ratio < 0.80)
           c = #0914ea;
         else 
           c = #ea0909;
       
         stroke(c);  
         line(cities.get(i).location.x, cities.get(i).location.y,cities.get(j ).location.x, cities.get(j).location.y);
       }
     }
   }
   text("red = 80%++"   ,20,10);
   text("blue = 60%++" ,20,20);
   text("green = 40%++ ",200,10);
   text("yellow = 20%++" ,200,20);
   text("purple = 10%++ " ,400,10);
     
  }
  int calculCumulativeWeight(){
    int total = 0;
    for(int i = 1 ; i <= antAmount ; i++)
      total += i;
    return total;
  }
  
  
  void calculHomogenity(){
    
    float targetEcartType = (float)antAmount / cityAmount;
    float maxEcartType = (antAmount - targetEcartType) + (targetEcartType * (cityAmount-1)); // antAmount - targetEcartType + targetEcartType * cityAmount
    float totalEcartType = 0;
    
    //maximun = 190
    float averageEcartType; // la moyenne de la difference avec le target ecart type
    for(int i = 0 ; i < cityAmount ; i++){
      int [] histogramme = new int[cityAmount];
      float accumulation = 0;
      for(int j = 0 ; j < antAmount ; j++)
        histogramme[ants.get(j).path.get(i)]++;
      //on regarde l histogramme 
      for(int j = 0 ; j < cityAmount ; j++)
        accumulation += (float)abs(histogramme[j] - targetEcartType);
      totalEcartType += accumulation;
    }
    averageEcartType = (float)totalEcartType / cityAmount;
    
    generationInfo.homogenity = ((float)averageEcartType / maxEcartType) * 100;
    
  }  
}