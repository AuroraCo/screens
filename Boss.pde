/*
 *   Class used for the final boss
 */
class Boss extends Chara{
  
  ArrayList<Bullet> clip = new ArrayList<Bullet>(); // Array list of bullets still in the post
  ArrayList<Bullet> fired = new ArrayList<Bullet>(); // Array list of bullets that have been fired
  boolean firing; // Boolean to check if we are currently shooting bullets
  int bulletCooldownMax = 1; // Max cooldown on bullet firing
  int bulletCooldown; // Cooldown timer
  int bulletAngle = 140; // Angle of bullet being fired 
  int bulletDamage = 1; // Damage the bullets deal
  String curString; // Used to keep track of what our initial string was, mainly for math purposes
  int hitCooldown = -1; // Used to keep track of cooldown on boss
  int firingTimer = -1; // Used for timing firing
  int cycleTimer = -1; // Used to keep track of the boss' cycles
  int stringPos; // Used to keep track of where in the string we are, almost like a giant for loop
  String strings[]; // Array of strings
  int stringsOriginalLength; // Used for keeping track of the original length of the array
  // Variables for keeping track of letter positions
  int kerningX = 14; // Default x kerning
  int kerningY = 20; // default y kerning
  int x; // Keeps track of x pos of letters
  int y; // keeps track of y pos of letters
  
  /*
   *   Boss constructor
   *   @param pos   Initial position of boss enemy
   */
  Boss(PVector pos){
    super(pos, new PVector(0,0), 10, 10);
    strings = loadStrings("bossTexts.txt");
    health = strings.length;
    stringsOriginalLength = strings.length;
    w=301;
    h=125;
    
  }
  
  /*
   *   Basic update method, used to run standard character updates
   */
  void update(){
    super.update();
    vel.y = (pos.y < 40) ? map(pos.y, -200, 35, 15, 1) : 0;
    if(hitCooldown >= 0) hitCooldown--;
    if(!firing && pos.y >= 40) cycle();
    if(!firing && cycleTimer == 60) { firing = true; firingTimer=300; bulletAngle = 140;}
    if(clip.size() == 0 && firing) firing = false;
    if(cycleTimer == 0) hit(1);
    if(firing) shoot();
    for(int i=0;i<clip.size();i++) clip.get(i).update();
    for(int i=0;i<fired.size();i++) {
      Bullet b = fired.get(i);
      b.update(); 
      if(b.hitCharaCircle(player)){
        fired.remove(i);
        player.hit(5);
      }
    }
  }
  
  /*
   *   Move bullets from the clip to the fired array lists, giving them a programmatically generated angle and vector
   */
  void shoot(){
    for(int i=0;i<clip.size();i++){
      Bullet b = clip.get(i);
      b.sliding = false;
      b.buzzing = true;
      b.vel = new PVector(-(b.pos.x - (pos.x + w/2)), -(b.pos.y - (pos.y + h/2))).mult(.1);
    }
    if(bulletCooldown <= 0 && clip.size() > 0){
      Bullet oldB = clip.get(clip.size()-1);
      Bullet b = new Bullet(oldB.pos.copy(), oldB.vel.copy(),oldB.bulletType,oldB.scale,oldB.buzzing,oldB.sliding);
      PVector v = PVector.fromAngle(radians(bulletAngle));
      b.buzzing = false;
      v.mult(6-map(strings.length,stringsOriginalLength,0,.5,0)); 
      bulletCooldownMax = (strings.length >= stringsOriginalLength/4) ? 1 : 0;
      b.vel = v;
      bulletAngle -= (strings.length >= stringsOriginalLength/2) ? (strings.length >= stringsOriginalLength/4) ? 19 : 14 : 19;
      if(bulletAngle <= 40) bulletAngle += 100;
      fired.add(b);
      if(firingTimer <= 0) clip.remove(oldB);
      bulletCooldown = bulletCooldownMax;
    }else bulletCooldown--;
    if(firingTimer > 0) firingTimer--;
  }
  
  /*
   *   Method used to cycle the boss
   */
  void cycle(){
    if(cycleTimer == -1) {
      clip.clear();
      if(strings.length > 0){
        curString = strings[0];
        strings = subset(strings, 1);
        cycleTimer = curString.length()*10+300;
        stringPos = 0;
      }
      x = 40;
      y = (h/2-((int)(curString.length()*kerningX/(w-30))+1)*kerningY/2 > 20) ? h/2-(int)((curString.length()*kerningX/(w-30))+1)*kerningY/2 : 20;
    }
    else {
      cycleTimer--;
      if(cycleTimer%10 == 0 && stringPos < curString.length()) {
        reloadClip(curString);
        stringPos++;
      }
    }
  }
  
  /*
   *   Used to reload the string in the post
   */
  void reloadClip(String s){
    if(x > w-35) {
      x = 40; 
      y+= kerningY;
    }
    if(s.charAt(stringPos) == ' '){ //<>//
      int nextword = 0;
      for(int j=stringPos+1;j<s.length();j++){
        if(s.charAt(j) != ' ') nextword+=kerning(s.charAt(j));
        else break;
      }
      if(x + nextword > w-35){
        x = 40; 
        y+= kerningY;
      } else if(x > 40) x+= kerningX;
    }else if(s.charAt(stringPos) == '*'){
      stringPos++;
      clip.add(new Bullet(new PVector(pos.x+x,pos.y+y), new PVector(vel.x,vel.y), String.valueOf(s.charAt(stringPos)), 20, false, true));
      x+=kerning(s.charAt(stringPos));
    }else { 
      clip.add(new Bullet(new PVector(pos.x+x,pos.y+y), new PVector(vel.x,vel.y), String.valueOf(s.charAt(stringPos)), 20, false, false));
      x+=kerning(s.charAt(stringPos));
    }
  }
  
  void hit(int damage){
    if(hitCooldown < 0){
      if(alive){
        health -= damage;
        if(health <= 0) alive = false;
        hitCooldown = 60;
      }
    }
  }
  
  /*
   *   Draw method, overrides basic one
   */
  void drawMe(){
    pushMatrix();
    
    translate(pos.x,pos.y);
    noStroke();
    fill(21,21,21,(firing) ? 200 : 100);
    int offset = (firing) ? 3 : 1;
    rect(33,0+offset,w-49,h);
    triangle(33,h+offset,33,h-20+offset,13,h-10+offset);
    fill(255);
    rect(33,0,w-49,h);
    triangle(34,h,34,h-20,14,h-10);
    fill(29,233,182);
    ellipse(9,h-34,46,46);
    if(health < stringsOriginalLength){
      stroke(21,21,21,250-health*25);
      strokeWeight((stringsOriginalLength-health)/2);
      line(150, h, 130, h-20);
      line(130, h-20, 140, h-30);
      line(130, h-20, 115, h-25);
      line(90, h, 95, h-15);
      line(95, h-15, 90, h-20);
      line(120, 0, 125, 18);
      line(125, 18, 126, 30);
      line(200, 0, 193, 9);
      line(193, 9, 190, 20);
      line(193, 9, 200, 18);
      noStroke();
    }
    
    popMatrix();
  }
}