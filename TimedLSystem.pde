import java.util.HashMap;

class TimedLetter {
  int letter;
  float age;
  
  TimedLetter(int l, float a) {
    letter = l;
    age = a;
  }
  
  TimedLetter(String s) {
    letter = (int)s.charCodeAt(0);
    //letter = (int)s.charAt(0);
    if ( s.length() > 1 )
      age = float(s.substring(1));
    else
      age = 0;
    //println(toString());
  }
  
  TimedLetter clone() {
    return new TimedLetter(letter, age);
  }
  
  String toString() {
    return "(" + letter + ", " + age + ")";
    //return String.format( "(%c, %f)", letter, age );
  }
}
  
ArrayList<TimedLetter> parseSequence( String s ) {
  ArrayList<TimedLetter> sentence = new ArrayList<TimedLetter>();
  String matches[][] = matchAll(s, "([a-zA-Z]([-+]?[0-9]*\\.?[0-9]+)?)|.");
  //while ( matcher.find() ) {
  for ( String[] m : matches ) {
    TimedLetter tl = new TimedLetter( m[0] );
    sentence.add(tl);
    //println(tl.toString());
  }
  return sentence;
} 

class TimedLSystem {
  ArrayList<TimedLetter> sentence;
  HashMap<Integer, ProductionRule> ruleset;
  int generation;  // generation #
  
  TimedLSystem() {
    sentence = new ArrayList<TimedLetter>();
    ruleset = new HashMap<Integer, ProductionRule>();
    generation = 0;
  }
  
  void setAxiom(String s) {
    sentence = parseSequence(s);
  }
  
  void addRule(char pred, float life, String b, float prob) {
    ProductionRule rule = ruleset.get(int(pred));
    if (rule != null) {
      // if there is already a rule for this predecessor, then
      // append it to the production set (the production will
      // become stochastic if it isn't already)
      rule.addProduction(b, prob);
    } else {
      // there is no production specified for this predecessor, so create it
      rule = new ProductionRule();
      rule.lifeSpan = life;
      rule.addProduction(b, prob);
      ruleset.put(int(pred), rule);
    }
  }
  
  // Add rule with probability of 1.0
  void addRule(char pred, float life, String b) {
    addRule(pred, life, b, 1);
  }
  
  // Evolve system with timestep deltaT. Careful not to increment by larger
  // than the lifespan of a production rule.
  void generate(float deltaT) {
    ArrayList<TimedLetter> nextgen = new ArrayList<TimedLetter>();
    // For every letter in the sentence
    for ( TimedLetter curr : sentence ) {      
      // increment the age for each letter
      curr.age += deltaT;
      
      //println("looking up " + char(curr.letter));
      ProductionRule rule = ruleset.get(int(curr.letter));
      if ( rule != null && curr.age >= rule.lifeSpan ) {
        //println("found rule");
        nextgen.addAll(rule.getPoduction());
      } else {
        // replace it with itself if it doesn't match one of our rules
        nextgen.add(curr);
      } 
    }
    
    sentence = nextgen;
    generation++;
    //println( toString() );
  }
  
  int getGeneration() { return generation; }
  
  ArrayList<TimedLetter> getSentence() { return sentence; }
  
  String toString() {
    int size = sentence.size();
    String[] sl = new String[size];
    for ( int i = 0; i < size; ++i ) {
      sl[i] = sentence.get(i).toString();
    }
    return join(sl, "");
  }
}

// Encapsulates a single successor to a production rule and its weight (for stochastic systems).
// These are combined into ProductionRule objects.
class Production {
  ArrayList<TimedLetter> successor;
  float weight;
  
  Production(ArrayList<TimedLetter> b, float w) {
    successor = b;
    weight = w;
  }
  
  Production(String s, float w) {
    successor = parseSequence(s);
    weight = w;
  }
}

// A production rule. Multiple productions can be specified for a single
// predecessor in the case of stochastic L-systems.
class ProductionRule {
  float lifeSpan;
  ArrayList<Production> prodList;
  float totalWeight;
  
  ProductionRule(String b) {
    this();
    addProduction(b);
  }
  
  ProductionRule() {
    totalWeight = 0;
    prodList = new ArrayList<Production>();
  }
  
  void addProduction(String b, float weight) {
    prodList.add(new Production(b, weight));
    totalWeight += weight;
  }
  
  void addProduction(String b) {
    addProduction(b, 1);
  }
  
  ArrayList<TimedLetter> getPoduction() {
    // Select a random production based on their weights
    ArrayList<TimedLetter> prod = new ArrayList<TimedLetter>();
    float r = random(0, totalWeight);
    for (int i = 0; i < prodList.size(); i++) {
      r -= prodList.get(i).weight;
      if ( r < 0 ) {
        // Create a clone of the production to return.
        for ( TimedLetter l : prodList.get(i).successor ) {
          prod.add( l.clone() );
        }
        break;
      }
    }
    return prod;
  }
}
