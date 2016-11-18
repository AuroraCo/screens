/*
 *   Class used for managing the player, extension of the base character class
 */
class Player extends Chara{
  
  float damp = 0.8; // Dampener for slowing down player
  
  int maxHealth; // The max health a player can have
  int maxBulletCooldown = 10; // The max cooldown a bullet can have while shooting
  int bulletCooldown = 0; // Cooldown for bullet
  
  boolean facingRight,showHitbox,facingUp; // Booleans for telling if we're facing right or if we should show the hitbox
  int curRotation; // Used for animating the rotation of the player
  ArrayList<Bullet> bullets = new ArrayList<Bullet>(); // Array list of bullets
  
  /*
   *   Player constructor
   *   @param pos Vector   position of player
   *   @param health   Health of player
   *   @param diam   Diameter of player 
   */
  Player(PVector pos, int health, int diam){
    super(pos, new PVector(0,0), health, diam);
    maxHealth = health;
  }
  
  /*
   *   Used for updating the player object
   */
  void update(){
    vel.mult(damp);
    super.update();
    handleWalls();
    bulletIterate();
  }
  
  /*
   *   Handles collision for the player
   */
  void handleWalls(){
    if(pos.x <= (width/3)+diam/2+diam/8) {pos.x = (width/3)+diam/2+diam/8; vel.x = 0;}
    if(curStage == SCROLLER_HELL){ if(pos.x >= (width/3*2)-diam/2-diam/1.25) {pos.x = (width/3*2)-diam/2-diam/1.25; vel.x = 0;} }
    else if(pos.x >= (width/3*2)-diam/2-diam/8) {pos.x = (width/3*2)-diam/2-diam/8; vel.x = 0;}
    if(curStage == BOSS_HELL){ if(pos.y <= 200+diam/2+diam/8) {pos.y = 200+diam/2+diam/8; vel.y = 0;} }
    else if(pos.y <= (height/26)+diam/2+diam/8) {pos.y = (height/26)+diam/2+diam/8; vel.y = 0;}
    if(pos.y >= (height-height/12)-diam/2-diam/8) {pos.y = (height-height/12)-diam/2-diam/8; vel.y = 0;}
  }
  
  /*
   *   Used to shoot the bullets
   */
  void shoot(){
    if(bulletCooldown <= 0){
      int vel_x = (facingRight) ? 20 : -20;
      bullets.add(new Bullet(new PVector(pos.x,pos.y), new PVector(vel_x, 0), alphabet[(int)random(26)], 20, false, false));
      bulletCooldown = maxBulletCooldown;
    }else bulletCooldown--;
  }
  
  /*
   *   Goes through the array of bullets
   */
  void bulletIterate(){
    for(int i = 0; i < bullets.size(); i++){
      Bullet b = bullets.get(i);
      b.update();
      if(b.pos.x > width + b.diam || b.pos.x < 0 - b.diam || b.pos.y > height+b.diam || b.pos.y < 0 - b.diam){
        bullets.remove(b);
      }
    }
  }
  
  /*
   *   Moves the character based on acceleration
   */
  void move(PVector acc) {
    vel.add(acc);
  }
  
  /*
   *   Overridden draw method
   */
  void drawMe(){ 
    pushMatrix();
    translate(pos.x,pos.y);
    
    if(!facingUp){
      if(facingRight){ // Rotate based off of if we're facing right or left
        if(curRotation < 180){
          curRotation+=20;
        }
      }else if(curRotation > 0){
        curRotation-=20;
      }
    }else if(curRotation > 90) curRotation-=5;
    else if(curRotation < 90) curRotation+=5;
    
    rotate(radians(curRotation));
    
    noFill();
    stroke(10);
    strokeWeight(3);
    triangle(-diam/2, 0, diam/2, -diam/2, diam/2, diam/2);
    
    if(showHitbox){ // Show the hitbox overlayed
      noStroke();
      fill(55,225,225);
      ellipse(diam/8,0,diam,diam);
    }
    
    popMatrix();
  }
}