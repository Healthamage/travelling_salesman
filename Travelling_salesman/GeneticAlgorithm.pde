class GeneticAlgorithm{
  GenerationInfo generationInfo = new GenerationInfo();
  final float defaultShuffleMutateRate = 5;
  final float defaultSwapMutateRate = 10;
  final float defaultPairMutateRate = 10;
  int agentAmount = 100;
  int bestAgentAmount = 10; // must be squareRoot of agentAmount

  float homogeneity;
  float shuffleMutateRate = 5;
  float swapMutateRate = 10;
  float pairMutateRate = 10;
  int maxCitySwap;
  ArrayList<Agent> agents = new ArrayList<Agent>();
  GeneticAlgorithm(){
    for(int i = 0 ; i < agentAmount ; i++)
      agents.add(new Agent());
    maxCitySwap = (cityAmount / 3) - 1;
  }
  void update(){
    calculHomogenity();
    adjustMutationWithHomogenity();
    evaluation();
    reproduction();
    mutation();
    generationInfo.generationCount++;
  }
  
  void display(){
    
    drawBest();
    drawGenerationInfo();
  }
  void evaluation(){

    for(Agent a:agents)
      a.calculFitness();
    java.util.Collections.sort(agents);
    
    generationInfo.bestFitness = agents.get(0).fitness;
    generationInfo.bestPath = (ArrayList<Integer>)agents.get(0).path.clone();
    float totalFitness = 0;
    for(Agent a:agents)
      totalFitness += a.fitness;
    generationInfo.gain = generationInfo.averageFitness - totalFitness / agentAmount;
    generationInfo.averageFitness = totalFitness / agentAmount;
 
  }
  
  void reproduction(){
    
    ArrayList<Agent> bestAgents = new ArrayList<Agent>();
    for(int i = 0 ; i < bestAgentAmount ; i++)
      bestAgents.add(agents.get(i));
      
    ArrayList<Agent> childs = new ArrayList<Agent>();
    for(int i = 0 ; i < bestAgentAmount ; i++){
      for(int j = 0 ; j < bestAgentAmount ; j++){
        ArrayList<Integer> path = (ArrayList<Integer>)bestAgents.get(i).path.clone();
        int limit = (int)cityAmount / 2;
        for(int k = 0 ; k < limit ; k++){
          //swap index
          int swapFemaleValue = bestAgents.get(j).path.get(k);
          int swapMaleValue = path.get(k);
          int swapMaleIndex = path.indexOf(swapFemaleValue);
          
          //on met l index du mal a celui de la female
          path.set(k,(Integer)bestAgents.get(j).path.get(k));
          //on va changer celui que on avais
          path.set(swapMaleIndex,swapMaleValue);
        }

        childs.add(new Agent(path));
      }
    }
      
    agents = childs;
    
  }
  
  void mutation(){

    for(Agent a:agents){
      //Mutation par section
      if(random(100) < shuffleMutateRate){
        //selection du path a muter
        int startMutationIndex = (int)random(cityAmount);
        int endMutationIndex = (int)random(cityAmount);
        if(endMutationIndex < startMutationIndex){
          int temp = endMutationIndex;
          endMutationIndex = startMutationIndex;
          startMutationIndex = temp;
        }
        //stockage des villes dans le champs de changement
        ArrayList<Integer> newPath = new ArrayList<Integer>();
        ArrayList<Integer> cityIndexPool = new ArrayList<Integer>();
        for(int i = startMutationIndex ; i <= endMutationIndex ; i++)
          cityIndexPool.add(a.path.get(i));
        //regeneration des villes de facon aleatoire
        int cityIndex = 0 ;  
        int poolSize = cityIndexPool.size();
        for(int i = startMutationIndex ; i <= endMutationIndex ; i++){
          while(newPath.contains(cityIndexPool.get(cityIndex = (int)random(poolSize)))){}
          newPath.add(cityIndexPool.get(cityIndex));
        }
        
        //on remove l ancien path et on insert le nouveau
        a.path.removeAll(cityIndexPool);
        a.path.addAll(startMutationIndex,newPath);
      }
      
      //Mutation par swap
      if(random(100) < swapMutateRate){
        int swapAmount = (int)random(1,maxCitySwap);

        int firstSwapIndex = (int)random(cityAmount-(swapAmount+1));
        int secondSwapIndex = 0;
        //we find avaible second swap Index
        while(!((secondSwapIndex = (int)random(cityAmount-(swapAmount+1))) > firstSwapIndex + swapAmount ||
                 secondSwapIndex < firstSwapIndex - swapAmount)){}
        
        ArrayList<Integer> firstSequence = new ArrayList<Integer>();
        ArrayList<Integer> secondSequence = new ArrayList<Integer>();
        for(int i = 0 ; i < swapAmount;i++){
          firstSequence.add(a.path.get(firstSwapIndex + i));
          secondSequence.add(a.path.get(secondSwapIndex + i));
        }
        a.path.removeAll(firstSequence);
        a.path.addAll(firstSwapIndex,secondSequence);
       
        //remove secondSequence with for to avoid removing just added secondSequence
        for(int i = 0 ; i < swapAmount ; i++)
          a.path.remove(secondSwapIndex);

        a.path.addAll(secondSwapIndex,firstSequence);

      }
      
      //Mutation par Pair
      if(random(100) < pairMutateRate){
        int swapAmount = 2;
        int firstSwapIndex = (int)random(cityAmount-(swapAmount+1));
        int secondSwapIndex = 0;
        //we find avaible second swap Index
        while(!((secondSwapIndex = (int)random(cityAmount-(swapAmount+1))) > firstSwapIndex + swapAmount ||
                 secondSwapIndex < firstSwapIndex - swapAmount)){}
        
        ArrayList<Integer> firstSequence = new ArrayList<Integer>();
        ArrayList<Integer> secondSequence = new ArrayList<Integer>();
        for(int i = 0 ; i < swapAmount;i++){
          firstSequence.add(a.path.get(firstSwapIndex + i));
          secondSequence.add(a.path.get(secondSwapIndex + i));
        }
        
        //maintenant on attache les pair
        int temp = firstSequence.get(0);
        a.path.set(firstSwapIndex,secondSequence.get(0));
        a.path.set(secondSwapIndex,temp);
        
        temp = firstSequence.get(1);
        a.path.set(firstSwapIndex+1,secondSequence.get(1));
        a.path.set(secondSwapIndex+1,temp);
      }
    }
  }
  
  void drawBest(){
    int bestIndex = 0;
    strokeWeight(5);
    for(int i = 0 ; i < cityAmount-1 ; i++){
      stroke(color(random(255),random(255),random(255)));
      line(cities.get(generationInfo.bestPath.get(i) ).location.x, cities.get(generationInfo.bestPath.get(i) ).location.y,
           cities.get(generationInfo.bestPath.get(i+1) ).location.x, cities.get(generationInfo.bestPath.get(i+1) ).location.y);
    }
           
    noFill();
    stroke(#e50404);
    ellipse(cities.get(generationInfo.bestPath.get(0) ).location.x, cities.get(generationInfo.bestPath.get(0) ).location.y,20,20);
    ellipse(cities.get(generationInfo.bestPath.get(cityAmount-1) ).location.x, cities.get(generationInfo.bestPath.get(cityAmount-1) ).location.y,20,20);
        
  }
  
  void drawGenerationInfo(){
    
    text("Generation Algorithm " ,20,10);
    text("generation count: " + generationInfo.generationCount,20,20);
    text("bestFitness: " + generationInfo.bestFitness,200,10);
    text("averageFitness: " + generationInfo.averageFitness,200,20);
    text("generation gain: " + generationInfo.gain,400,10);
    text("generation homogenity: " + nfc(generationInfo.homogenity*100,2) + "%" ,400,20);
    
    text("shuffleMutateRate: " + nfc(shuffleMutateRate,2)+ "%",600,10);
    text("swapMutateRate: " + nfc(swapMutateRate,2)+ "%",600,20);
    text("pairMutateRate: " + nfc(pairMutateRate,2) + "%" ,600,30);
  }
  
  //homogeneity will influence mutationRate
  void calculHomogenity(){
    
    float targetEcartType = (float)agentAmount / cityAmount;
    float maxEcartType = (agentAmount - targetEcartType) + (targetEcartType * (cityAmount-1)); // antAmount - targetEcartType + targetEcartType * cityAmount
    float totalEcartType = 0;
    
    //maximun = 190
    float averageEcartType; // la moyenne de la difference avec le target ecart type
    for(int i = 0 ; i < cityAmount ; i++){
      int [] histogramme = new int[cityAmount];
      float accumulation = 0;
      for(int j = 0 ; j < agentAmount ; j++)
        histogramme[agents.get(j).path.get(i)]++;
      //on regarde l histogramme 
      for(int j = 0 ; j < cityAmount ; j++)
        accumulation += (float)abs(histogramme[j] - targetEcartType);
      totalEcartType += accumulation;
    }
    averageEcartType = (float)totalEcartType / cityAmount;
    
    generationInfo.homogenity = (float)averageEcartType / maxEcartType;
  }  
  
  void adjustMutationWithHomogenity(){
    shuffleMutateRate = defaultShuffleMutateRate * generationInfo.homogenity *2 ;
    swapMutateRate = defaultSwapMutateRate * generationInfo.homogenity *2;
    pairMutateRate = defaultPairMutateRate * generationInfo.homogenity *2;
    
  }
}