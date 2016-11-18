/*
 *   Class used for managing screens, objects that hold the enemy objects
 */
class Screen extends Chara{
  // Colors for the screens
  color GP_DARK = color(11,128,67); 
  color GP_LIGHT = color(15,157,88);
  
  int cycleTimer = -1; // Used to keep track of the cycle
  int cycleTimerMax; // Used to keep track of the initial cycle timer for this screen
  int randWaitTimer = -1; // Used to add a random wait before the cycle begins (up to 5 seconds)
  boolean onLeft; // Used to detemrine which side screen is on
  String[] strings; // Used for generating posts
  boolean hasAppeared; // Keeping track of if the screen has appeared at all
  
  ArrayList<Enemy> posts = new ArrayList<Enemy>(); // Array list of posts inside all screens
  
  /*
   *   Screen constructor
   *   @param pos Vector   position of screen
   *   @param vel Vector   Velocity of screen
   *   @param onLeft   Used to determine if the screen is on the left or right
   *   @param maxCharacters   Used to determine max character count of posts on this screen
   */
  Screen(PVector pos, PVector vel, boolean onLeft, String[] strings){
    super(pos, vel, 0, 0);
    this.onLeft = onLeft;
    this.strings = strings;
    addPosts();
    hasAppeared = false;
  }
  
  /*
   *   Overriden update method
   */
  void update(){
    super.update();
    if(randWaitTimer >= 0) randWaitTimer--;
    if(randWaitTimer == 0) {
      int stringAverage = 0;
      for(int i=0;i<strings.length;i++) stringAverage+=strings[i].length();
      stringAverage = stringAverage/strings.length;
      cycleTimer = cycleTimerMax = 1000+stringAverage*10;
    }
    if(hasAppeared && cycleTimer > 800) cycleTimer = 800;
    if(posts.size() == 0 && cycleTimer > 250) cycleTimer = 250;
    if(cycleTimer >= 250) {
      cycleTimer--;
      if(onLeft) vel.x = (pos.x < 0) ? map(pos.x, -348, -1, 25, 1) : 0;
      else vel.x = (pos.x > width/3*2) ? -map(pos.x, width+15, 667, 25, 1) : 0;
    }else if(cycleTimer > 0) {
      if(onLeft) vel.x = (pos.x > -348) ? -map(pos.x, -1, -348, 1, 30) : 0;
      else vel.x = (pos.x < width+15) ? map(pos.x,667, width+15, 1, 30) : 0;
      cycleTimer--;
    }else if(cycleTimer == 0 && posts.size() == 0){
      if(onLeft) screensLeft.remove(this);
      else screensRight.remove(this);
      cycleTimer--;
    }else if(cycleTimer == 0) {
      cycleTimer--;
      hasAppeared = true;
    }
    for(int i=0;i<posts.size();i++) posts.get(i).update();
  }
  
  /*
   *   Populates the posts in the array for each cycle
   */
  void addPosts(){
    for(int i=0;i<strings.length;i++){
      posts.add(new Enemy(new PVector(pos.x+16, pos.y+150*i+75), vel, 10, this, strings[i]));
    }
  }
  /*
   *   Start the cycle of sliding in and out
   */
  void startCycle(){
    randWaitTimer = (int)random(300);
  }
  
  /*
   *   Overriden draw method
   */
  void drawMe(){
    pushMatrix();
    
    translate(pos.x,pos.y);
    int min = width/3;
    int max = (width/3)*2;
    
    noStroke();
    fill(245);
    rect(0, 0, max-min, height);
    fill(GP_LIGHT);;
    rect(0, 0, max-min, height/12);
    fill(GP_DARK);
    rect(0, 0, max-min, height/26);
    rect(0, height-height/12, max-min, height/12);
    strokeWeight(3);
    stroke(250);
    noFill();
    ellipse(((max-min)/2), height-height/24, height/20, height/20);
    
    popMatrix();
  }
}