class Agent implements Comparable{
  
  float fitness;
  ArrayList<Integer> path = new ArrayList<Integer>();
  
  //default constructor
  Agent(){
    int cityIndex;
    for(int i = 0 ; i < cityAmount ; i++){
      while(path.contains(cityIndex = (int)random(cityAmount))){}
      path.add(cityIndex);
    }
  }
  
  //constructor from parents
  Agent(ArrayList<Integer> path){
    this.path = path;
  }
  
  int compareTo(Object other){
    Agent agent = (Agent)other;
    return (int)(fitness - agent.fitness);
  }
}