/*
 *   Class used for managing enemy objects, extentions of character objects
 */
class Enemy extends Chara{
  
  Screen parent; // Parent screen
  ArrayList<Bullet> clip = new ArrayList<Bullet>(); // Array list of bullets still in the post
  ArrayList<Bullet> fired = new ArrayList<Bullet>(); // Array list of bullets that have been fired
  Bullet contactName; // Bullet that never moves aside from with screens or scrolling
  boolean firing; // Boolean to check if we are currently shooting bullets
  int bulletCooldownMax = 10; // Max cooldown on bullet firing
  int bulletCooldown; // Cooldown timer
  int bulletAngle; // Angle of bullet being fired 
  int bulletDamage = 1; // Damage the bullets deal
  String initialString; // Used to keep track of what our initial string was, mainly for math purposes
  boolean msgSent = false; // Used to keep track of scrolling enemies, whether a message was sent or rcv'd (for drawing purposes)
  
  PImage drop_shadow;
    
  /*
   *   Enemy constructor
   *   @param pos Vector   position of enemy
   *   @param vel Vector   Velocity of enemy
   *   @param health   Health of enemy
   *   @param parent   Parent screen
   *   @param maxCharacters   Used to determine the max character count of the post
   */
  Enemy(PVector pos, PVector vel, int health, Screen parent, String string){
    super(pos, vel, health, 10);
    this.parent = parent;
    w=301;
    h=125;
    contactName = new Bullet(new PVector(pos.x-5,pos.y+105), new PVector(vel.x,vel.y), "H", 40, false, false);
    reloadClip(string);
    firing = false;
    initialString = string;
    bulletAngle = (pos.y < height/4) ? (parent.onLeft) ? -50 : 230 : (parent.onLeft) ? 50 : 130;
  }
  
  /*
   *   Enemy constructor 2
   *   @param pos Vector   position of enemy
   *   @param vel Vector   Velocity of enemy
   *   @param health   Health of enemy
   *   @param msgSent   Used to keep track of the text should display on the left or right
   *   @param maxCharacters   Used to determine the max character count of the post
   */
  Enemy(PVector pos, PVector vel, int health, boolean msgSent, String string){
    super(pos, vel, health, 10);
    this.msgSent = msgSent;
    w=301;
    h=125;
    if(!msgSent) contactName = new Bullet(new PVector(pos.x-5,pos.y+105), new PVector(vel.x,vel.y), "H", 40, false, false);
    reloadClip(string);
    firing = false;
    initialString = string;
  }
  
  /*
   *   Update method for handling enemies, overrides basic one
   */
  void update(){
    super.update(); // Call base update method
    if(parent != null){
      if(parent.cycleTimer == -1) reloadClip(initialString);
      moveClip(); 
      if(parent.cycleTimer <= parent.cycleTimerMax-700 && parent.cycleTimer >= 300) {
        firing = true;
        checkHit();
      }
      else firing = false;
      if(firing) shoot();
      for(int i=0;i<clip.size();i++) clip.get(i).update();
      for(int i=0;i<fired.size();i++) {
        Bullet b = fired.get(i);
        b.update(); 
        if(b.pos.dist(b.endPos) < 1) fired.remove(this);
        if(b.hitCharaCircle(player)){
          fired.remove(i);
          player.hit(10);
        }
      }
      contactName.update();
    }else{ 
      moveClip();
      for(int i=0;i<clip.size();i++) {
        Bullet b = clip.get(i);
        b.update(); 
        if(b.hitCharaCircle(player)){
          clip.remove(i);
          player.hit(10);
        }
      }
      if(contactName != null){
        contactName.update();
        if(contactName.hitCharaCircle(player)){
          player.hit(1);
          contactName.buzzing = true;
        }
      }
    }
  }
  
  /*
   *   Used to reload the string in the post
   */
  void reloadClip(String s){
    clip.clear();
    int kerningX = 14;
    int kerningY = 17;
    int x = 40;
    int y = (h/2-((int)(s.length()*kerningX/(w-30))+1)*kerningY/2 > 20) ? h/2-(int)((s.length()*kerningX/(w-30))+1)*kerningY/2 : 20;
    if(msgSent){
      int totalLength = 0;
      for(int i=0;i<s.length();i++){
        totalLength += kerning(s.charAt(i));
      }
      x = (totalLength < w-90) ? w-20-totalLength : 60;
      for(int i=0;i<s.length();i++){
        
        if(x > w-20) {
          x = 60; 
          y+= kerningY;
        }
        if(s.charAt(i) == ' '){
          int nextword = 0;
          for(int j=i+1;j<s.length();j++){
            if(s.charAt(j) != ' ') nextword+=kerning(s.charAt(j));
            else break;
          }
          if(x + nextword > w-20){
            x = 60; 
            y+= kerningY;
          } else if(x > 60) x+= kerningX;
        } else { 
          clip.add(new Bullet(new PVector(pos.x+x,pos.y+y), new PVector(vel.x,vel.y), String.valueOf(s.charAt(i)), 20, false, false));
          x+=kerning(s.charAt(i));
        }
      }
    }else for(int i=0;i<s.length();i++){
      if(x > w-35) {
        x = 40; 
        y+= kerningY;
      }
      if(s.charAt(i) == ' '){ //<>// //<>// //<>//
        int nextword = 0;
        for(int j=i+1;j<s.length();j++){
          if(s.charAt(j) != ' ') nextword+=kerning(s.charAt(j));
          else break;
        }
        if(x + nextword > w-35){
          x = 40; 
          y+= kerningY;
        } else if(x > 40) x+= kerningX;
      } else { 
        clip.add(new Bullet(new PVector(pos.x+x,pos.y+y), new PVector(vel.x,vel.y), String.valueOf(s.charAt(i)), 20, false, false));
        x+=kerning(s.charAt(i));
      }
    }
  }
  
  /*
   *   Move bullets from the clip to the fired array lists, giving them a programmatically generated angle and vector
   */
  void shoot(){
    for(int i=0;i<clip.size();i++){
      Bullet b = clip.get(i);
      b.buzzing = true;
      b.vel = new PVector(-(b.pos.x - (pos.x + w/2)), -(b.pos.y - (pos.y + h/2))).mult(.1);
    }
    if(bulletCooldown <= 0 && clip.size() > 0){
      Bullet b = clip.get(clip.size()-1);
      PVector v = (pos.y < height/3 || pos.y > height/2) ? PVector.fromAngle(radians(bulletAngle)) : PVector.sub(player.pos,b.pos);
      b.endPos = player.pos.copy();
      b.buzzing = false;
      v = (pos.y < height/3 || pos.y > height/2) ? v.mult(abs(5+initialString.length()/50)) : v.div(90);
      b.vel = v;
      bulletAngle += (pos.y < height/4) ? (parent.onLeft) ? 9 : -9 : (parent.onLeft) ? -9 : 9;
      if((pos.y < height/4) ? (parent.onLeft) ? bulletAngle >= 10 : bulletAngle <= 170 : (parent.onLeft) ? bulletAngle <= -10 : bulletAngle >= 190) bulletAngle = (pos.y < height/4) ? (parent.onLeft) ? -50 : 230 : (parent.onLeft) ? 50 : 130;
      fired.add(b);
      clip.remove(b);
      bulletCooldown = bulletCooldownMax;
    }else bulletCooldown--;
  }
  
  /*
   *   Moving the clip with the post
   */
  void moveClip(){
    for(int i = 0; i < clip.size(); i++){
      Bullet b = clip.get(i);
      b.vel.x = vel.x;
      b.vel.y = vel.y;
    }
    if(contactName != null){
      contactName.vel.x = vel.x;
      contactName.vel.y = vel.y;
    }
  }
  
  /*
   *   Check if any of the bullets hit the player and apply damage accordingly
   */
  void checkHit(){
    for(int i=0;i<player.bullets.size();i++){
      Bullet b = player.bullets.get(i);
      if(b.hitCharaBox(this)){
        player.bullets.remove(b);
        hit(bulletDamage);
        if(!alive) parent.posts.remove(this);
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
    if(msgSent){
      fill(21,21,21,100);
      rect(44, 1, w-49, h);
      triangle(w-5, h+1, w-5, h-20+1, w+15, h-10+1);
      fill(224);
      rect(44, 0, w-49, h);
      triangle(w-5, h, w-5, h-20, w+15, h-10);
    }
    else{
      fill(21,21,21,(firing) ? 200 : 100);
      int offset = (firing) ? 3 : 1;
      rect(33,0+offset,w-49,h);
      triangle(33,h+offset,33,h-20+offset,13,h-10+offset);
      fill(255);
      rect(33,0,w-49,h);
      triangle(34,h,34,h-20,14,h-10);
      fill(29,233,182);
      ellipse(9,h-34,46,46);
      if(health < 10){
        stroke(21,21,21,250-health*25);
        strokeWeight((10-health)/2);
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
      
    }
    
    popMatrix();
  }
}