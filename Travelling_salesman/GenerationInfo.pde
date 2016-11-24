class GenerationInfo{
  
  int generationCount = 0;
  float bestFitness = 0;
  ArrayList<Integer> bestPath = new ArrayList<Integer>();
  float averageFitness = 0;
  float gain = 0;
  
  float homogenity;
  GenerationInfo(){}
}