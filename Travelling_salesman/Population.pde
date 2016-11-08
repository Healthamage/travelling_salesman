class Population{
  
  int generationCount = 0;
  int agentAmount = 225;
  int bestAgentAmount = 15; // must be squareRoot of agentAmount
  float averageFitness;
  float generationGain;
  
  float shuffleMutateRate = 5;
  float swapMutateRate = 20;
  int maxCitySwap;
  ArrayList<Agent> agents = new ArrayList<Agent>();
 
  Population(){
    for(int i = 0 ; i < agentAmount ; i++)
      agents.add(new Agent());
    maxCitySwap = (cityAmount / 3) - 1;
  }
  void update(){
    
    evaluation();
    drawBest();
    drawGenerationInfo();
    reproduction();
    mutation();
    generationCount++;
  }
  
  void evaluation(){
    float fitness = 0;
    float totalFitness = 0;
    for(Agent a:agents){
      for(int i = 0 ; i < cityAmount-1 ; i++)
        fitness += PVector.dist(cities.get(a.path.get(i)).location , cities.get(a.path.get(i+1)).location);
      a.fitness = fitness;
      totalFitness += fitness;
      fitness = 0;
    }
    generationGain = averageFitness - totalFitness/agentAmount;
    averageFitness = totalFitness/agentAmount;
    java.util.Collections.sort(agents);
    
    
    
    
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
    }
  }
  
  void drawBest(){
    int bestIndex = 0;
    for(int i = 0 ; i < cityAmount-1 ; i++){
      stroke(color(random(255),random(255),random(255)));
      line(cities.get(agents.get(bestIndex).path.get(i) ).location.x, cities.get(agents.get(bestIndex).path.get(i) ).location.y,
           cities.get(agents.get(bestIndex).path.get(i+1) ).location.x, cities.get(agents.get(bestIndex).path.get(i+1) ).location.y);
    }
           
    noFill();
    stroke(#e50404);
    ellipse(cities.get(agents.get(bestIndex).path.get(0) ).location.x, cities.get(agents.get(bestIndex).path.get(0) ).location.y,20,20);
    ellipse(cities.get(agents.get(bestIndex).path.get(cityAmount-1) ).location.x, cities.get(agents.get(bestIndex).path.get(cityAmount-1) ).location.y,20,20);
        
  }
  
  void drawGenerationInfo(){
    
    text("generation count: " +generationCount,20,10);
    text("bestScore: " + nfc(agents.get(0).fitness,2),200,10);
    text("averageScore: " + nfc(averageFitness,2),20,20);
    text("generationGain " + nfc(generationGain,2),200,20);
  }
  
}