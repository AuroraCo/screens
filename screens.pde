// Game states with quasi-random integers 
final int BULLET_HELL = 654165168;
final int SCROLLER_HELL = 9784651;
final int BOSS_HELL = 684324843;
final int YOU_WON = 789645351;
final int YOU_DIED = 68246868;
final int SPLASH_SCREEN = 57168272;

boolean first, firstAgain, poppedScreens; // Keep track of if we've populated screens

int curStage,lastStage; // Keep track of the current stage and last stages

PFont proxima; // Font used during the game
PFont proxima20; // smaller version of font
PFont proxima40; // Larger version of font
PImage splash; // Splash screen image
PImage background; // Background image

ArrayList<Screen> screensLeft = new ArrayList<Screen>(); // Screens that slide in from the left
ArrayList<Screen> screensRight = new ArrayList<Screen>(); // Screens that slide in from the right
ArrayList<Drop> dropsTop = new ArrayList<Drop>(); // The drops that appear for health and fire rate increases
ArrayList<Drop> dropsBottom = new ArrayList<Drop>(); // The drops that appear for health and fire rate increases
ArrayList<Enemy> scrollingEnemies = new ArrayList<Enemy>(); // Array list for enemies that scroll downward
int numScreens = 3; // The number of screens per side
String[] alphabet = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}; // Array that allows us to fire a random letter as a bullet
String[] dropTypes = {"health","fire_rate","maxHealth"}; // The different types of drops, currently unused but will be implemented when more drops are added
boolean paused; // Keeps track of if the game is paused



Player player; // Player character
Screen curScreenLeft,curScreenRight; // The currently selected screen
Boss boss; // Boss enemy type

AudioHandler song; // Audio handler class, to later be used with audio cues

int splashTimer = 300; // Countdown timer for the splash screen at the beginning
int intermissionTimer = -1;
int notificationTimer = -2;


void setup(){
  size(999,562);
  
  player = new Player(new PVector(width/2, height/2), 100, height/20); // Create the player
  boss = new Boss(new PVector(width/2-150,-200)); // TAKE OUT FOR FINAL GAME
  
  paused = false;
  
  textAlign(LEFT);
  
  proxima = loadFont("proxima.vlw");
  proxima20 = loadFont("proxima20.vlw");
  proxima40 = loadFont("proxima40.vlw");
  
  first = true;
  
  background = loadImage("bg.png");
  splash = loadImage("splash.png");

  
  curStage = lastStage = SPLASH_SCREEN; // Set the current stage to the splash screen
  
  song = new AudioHandler(this);
}

void draw(){
  if(curStage == SPLASH_SCREEN && focused) paused = false;
  if(focused && !paused){
    song.update();
    if(splashTimer >= 0) splashTimer--;
    if(splashTimer == 0) curStage = lastStage = BULLET_HELL;
    switch(curStage){ // Check which stage we're on and draw appropriately 
      case SPLASH_SCREEN:
        drawSplash();
        break;
      case YOU_WON:
        drawWin();
        break;
      case YOU_DIED:
        drawDeath();
        break;
      default:
        play(curStage);
    }
  }
  else{
    drawBG();
    player.update();
    drawSplash();
    song.pause();
    song = new AudioHandler(this);
    paused = true;
  }
}

/*
 *  Draws the splash screen
 */
void drawSplash(){
  drawBG();
  player.update();
  if(first || firstAgain){
    noStroke();
    image(splash,0,0);
    if(dropsTop.size() <= 0){
      for(int i=0;i<dropTypes.length;i++){
        dropsTop.add(new Drop(new PVector(width/2-(width/3-100)/2+((width/3-100)/(dropTypes.length-1))*i,height/2+60),dropTypes[i], dropsTop));
      }
    }
    for(int i=0;i<dropsTop.size();i++) dropsTop.get(i).update();
    if(splashTimer <= 1) dropsTop.clear();
    fill(255);
    textFont(proxima);
    textSize(48);
    text("Drops: ", width/2-90, height/2+20);
    text("wait " + (((int)splashTimer/60)+1) + " seconds", width/3,height/2+160);
    textSize(24);
    text("Health+   Fire Rate   Max Health+", width/3+15, height/2+100);
    text("warning: contains strong language", width/3-25, height/2+200);
    if(firstAgain){
      textFont(proxima20);
      textSize(20);
      text("but you've already seen this, haven't you?", width/3-20, height/2+230);
    }
  }else{
    noStroke();
    fill(26,36,126, 156);
    rect(0,0,width,height);
    fill(255);
    textFont(proxima);
    textSize(48);
    text("lets just skip this for you...", width/4-20,height/2-40);
    text("wait " + (((int)splashTimer/60)+1) + " seconds", width/3,height/2+160);
    textSize(24);
    text("warning: contains strong language", width/3-25, height/2+200);
    if(splashTimer == 240) splashTimer = 120;
  }
}

/*
 *   Draws the "Win" screen
 */
void drawWin(){
  drawBG();
  player.update();
  noStroke();
  fill(26,36,126, 156);
  rect(0,0,width,height);
  fill(255);
  textFont(proxima);
  textSize(48);
  text("u won nice", width/2-110, height/2-20);
}

/*
 *   Draws the "Game over" screen
 */
void drawDeath(){
  drawBG();
  noStroke();
  fill(26,36,126, 156);
  rect(0,0,width,height);
  fill(255);
  textFont(proxima);
  textSize(48);
  text("       u died dang\npress space 2 reset", width/3-50, height/2-20);
}

/*
 *  Draws the background, including player health and fire rate
 */
void drawBG(){
  background(background);
  int min = width/3;
  int max = (width/3)*2;
  
  noStroke();
  fill(250);
  rect(min, 0, max-min, height);
}

/*
 *  Draws the top/bottom bars of the background, including player health and fire rate
 */
void drawBGLite(color c){
  int min = width/3;
  int max = (width/3)*2;
  
  noStroke();
  fill(c);
  rect(min, 0, max-min, height/26);
  rect(min, height-height/12, max-min, height/12);
  strokeWeight(3);
  stroke(250);
  noFill();
  ellipse(min+((max-min)/2), height-height/24, height/20, height/20);
  fill(220);
  textFont(proxima20);
  textSize(20);
  text(player.health + "%", max-50, 16);
  noStroke();
  fill(255,255,255,128);
  arc(min+20, 18, 30, 30, PI+QUARTER_PI, PI+HALF_PI+QUARTER_PI);
  rect(max-55-player.maxHealth/4, 4, player.maxHealth/4, 12);
  fill(255);
  arc(min+20, 18, (11-player.maxBulletCooldown)*5, (11-player.maxBulletCooldown)*5, PI+QUARTER_PI, PI+HALF_PI+QUARTER_PI);
  rect(max-55-player.health/4, 4, player.health/4, 12);
  fill(c);
  rect(max-55-player.maxHealth/4, 4, 2, 3, 0, 0, 2, 0);
  rect(max-55-player.maxHealth/4, 13, 2, 3, 0, 2, 0, 0);
  
}

/*
 *   Used for drawing a notification at the beginning of the boss stage
 */
void drawNotification(){
  pushMatrix();
    
  translate(width/2-150, (notificationTimer >= 240) ? 240-notificationTimer : (notificationTimer <= 60) ? notificationTimer - 60 : 0);
  
  noStroke();
  fill(240);
  rect(0,0,300,50,0,0,3,3);
  fill(10);
  textFont(proxima20);
  textSize(20);
  text("A New Message Has Arrived!",20,30);
  
  
  popMatrix();
  if(notificationTimer >=0) notificationTimer--;
}

/*
 *  Populates the screen arrays
 */
void popScreens(){
  for(int i=0;i<numScreens;i++){
    String[] s = loadStrings("dialog.txt");
    String[] sCur = subset(s, i, 1);
    String[] sNew = split(sCur[0], "#");
    screensLeft.add(new Screen(new PVector(-348,0),new PVector(0,0),true,sNew));
    screensRight.add(new Screen(new PVector(width+15,0),new PVector(0,0),false,sNew));
  }
  poppedScreens = true;
}

/*
 *   Clears the stage of all enemies and gets it ready for reset
 *   @param stage   Stage we need to clear and reset
 */
void resetStage(int stage){
  screensLeft.clear();
  screensRight.clear();
  poppedScreens = false;
  dropsTop.clear();
  dropsBottom.clear();
  curScreenLeft = null;
  curScreenRight = null;
  scrollingEnemies.clear();
  boss = null;
  player = new Player(new PVector(width/2, height/2), 100, height/20);
  curStage = lastStage = SPLASH_SCREEN;
  boss = new Boss(new PVector(width/2-150,-200)); // TAKE OUT FOR FINAL GAME
  song.pause();
  song = new AudioHandler(this);
  splashTimer = 300;
  if(first) {first = false; firstAgain = true;}
  else if(firstAgain) firstAgain = false;
}

/*
 *  Sets the playing field for the game
 *  @param stage   Uses this int to check which stage of the game we're on
 */
void play(int stage){
  drawBG();
  
  if (up) player.move(upAcc);
  if (down) player.move(downAcc);
  if (left) player.move(leftAcc);
  if (right) player.move(rightAcc);
  
  if(stage == BULLET_HELL){
    drawBGLite(10);
    if (shootRight|| shootLeft) player.shoot();
    if(!poppedScreens) popScreens();
    if(screensLeft.size() > 0 && (curScreenLeft == null || curScreenLeft.cycleTimer == -1 && curScreenLeft.randWaitTimer == -1)) {
      for(int i=0;i<dropTypes.length;i++){
        dropsTop.add(new Drop(new PVector(width/2-(width/3-100)/2+((width/3-100)/(dropTypes.length-1))*i,height/3),dropTypes[i], dropsTop));
      }
      curScreenLeft = screensLeft.get(0);
      curScreenLeft.startCycle();
    }
    if(screensRight.size() > 0 && (curScreenRight == null || curScreenRight.cycleTimer == -1 && curScreenRight.randWaitTimer == -1)){ 
      for(int i=0;i<dropTypes.length;i++){
        dropsBottom.add(new Drop(new PVector(width/2-(width/3-100)/2+((width/3-100)/(dropTypes.length-1))*i,height/3*2),dropTypes[i], dropsBottom));
      }
      curScreenRight = screensRight.get(0); 
      curScreenRight.startCycle();
    }
    for(int i=0;i<dropsTop.size();i++) {
      dropsTop.get(i).update();
    }
    for(int i=0;i<dropsBottom.size();i++) {
      dropsBottom.get(i).update();
    }
    curScreenLeft.update();
    curScreenRight.update();
    if(screensLeft.size() == 0 && screensRight.size() == 0){
      curStage = SCROLLER_HELL;
      intermissionTimer = 300;
    }
  }
  if(stage == SCROLLER_HELL){
    player.facingUp = true;
    if(intermissionTimer <= 0){
      String[] s = loadStrings("texts.txt");
      int scrollSize = 0-150-150*s.length;
      if(scrollingEnemies.size() <= 0){
        for(int i=s.length-1;i>=0;i--){
          String[] sCur = split(s[i], '#');
          boolean msgSent = (sCur[0].equals("0")) ? true : false;
          scrollingEnemies.add(new Enemy(new PVector(width/3+16, 0-150-150*(s.length-i)), new PVector(0,0), 10, msgSent, sCur[1]));
        }
      }
      
      for(int i=0;i<scrollingEnemies.size();i++){
        Enemy e = scrollingEnemies.get(i);
        if(e.vel.y == 0) e.vel.y = 3;
        e.update();
        drawBGLite(color(11,128,67));
        
        if(i == scrollingEnemies.size()-1){
          noStroke();
          fill(156);
          rect(width/3*2-15, map(e.pos.y, scrollSize, height, height-height/12-110, height/26+10), 10, 100, 10);
          if(e.pos.y > height+20){
            intermissionTimer = 300;
            curStage = BOSS_HELL;
          }
        }
      }
    }else {
      intermissionTimer--;
      drawBGLite(color(11,128,67));
    }
  }
  if(stage == BOSS_HELL){
    player.facingUp = true;
    if(intermissionTimer == 1)  boss = new Boss(new PVector(width/2-150,-200));
    if(intermissionTimer <= 0) {
      if(notificationTimer == 0) boss.update();
      drawBGLite(color(11,128,67));
      if(notificationTimer == -2) notificationTimer = 300;
      if(notificationTimer > 0) drawNotification();
      if(!boss.alive) curStage = YOU_WON;
    }
    else {
      intermissionTimer--;
      drawBGLite(color(11,128,67));
    }
  }
  
  if(!player.alive) curStage = YOU_DIED;
  player.update();
}

/*
 *   Used for determining kerning of character
 *   @param c   Input character to find kerning for
 */
 int kerning(Character c){
   switch(c){
     case 'b':
     case 'h':
     case 'n':
     case 'o':
     case 'p':
     case 'q':
     case 'u':
       return 13;
     case 'i':
     case 'j':
     case 'l':
     case 'r':
     case 't':
       return 8;
     case 's':
       return 9;
     case 'm':
     case 'w':
       return 16;
     default:
       return 12;
   }
 }