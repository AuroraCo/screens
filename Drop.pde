/*
 *   Class used for managing drops such as power ups, health, etc.
 */
class Drop extends Chara{
  String type; // Keeps track of the type of drop this is
  int lifeTimer = 300; // Drops only stay alive for 5 seconds
  ArrayList<Drop> drops = new ArrayList<Drop>(); // Current array of drops
  
  /*
   *   Drop constructor
   *   @param pos   Keeps track of the position of the drop
   *   @param type   Sets the drop type
   */
  Drop(PVector pos, String type, ArrayList<Drop> drops){
    super(pos, new PVector(0,0),1,30);
    this.type = type;
    this.drops = drops;
  }
  
  
  /*
   *   Basic update method for the drop
   */
  void update(){
    checkHit();
    drawMe();
    lifeTimer--;
    if(!alive){
      for(int i=0;i<drops.size();i++) drops.get(i).lifeTimer=25;
      drops.remove(this);
    }
    if(lifeTimer == 0){
      drops.remove(this);
    }
  }
  
  /*
   *   Checks if the drop intersects with the player and then applies an effect on the player
   */
  void checkHit(){
    if(lifeTimer > 25){
      if(hitCharaCircle(player)){
        if(type == "fire_rate") if(player.maxBulletCooldown > 5) player.maxBulletCooldown--;
        
        if(type == "health") player.health = (player.health+20 <= player.maxHealth) ? player.health+=20 : player.maxHealth;
        
        if(type == "maxHealth") if(player.maxHealth+10 <= 200){ player.maxHealth+=10; player.health+=10;}
        
        alive = false;
      }
    }
  }
  
  /*
   *   Method for detecting character collision based upon bounding circle
   *
   */
  boolean hitCharaCircle(Chara c){
    float dx = pos.x - c.pos.x;
    float dy = pos.y - c.pos.y;
    float distance = sqrt(dx * dx + dy * dy);
    
    return distance < diam/2 + c.diam/2;
  }
  
  /*
   *   Method for drawing a drop on screen
   */
  void drawMe(){
    pushMatrix();
    
    translate(pos.x,pos.y);
    noStroke();
    int alpha = (lifeTimer > 25) ? 255 : lifeTimer*10;
    color fill = (type == "fire_rate" || type == "maxHealth") ? (type == "fire_rate") ? color(55,255,155,alpha) : color(55,155,255,alpha) : color(255,55,55,alpha); // Sets color based on the type drop
    fill(fill);
    ellipse(0,0,diam,diam);
    fill = (type == "fire_rate" || type == "maxHealth") ? (type == "fire_rate") ? color(55,255,155,160-frameCount%80*2) : color(55,155,255,160-frameCount%80*2) : color(255,55,55,160-frameCount%80*2); // Sets color based on the type drop
    fill(fill);
    ellipse(0,0,frameCount%80,frameCount%80);
    if(type == "fire_rate"){
      noStroke();
      fill(0,128);
      arc(0, 8, 30, 30, PI+QUARTER_PI, PI+HALF_PI+QUARTER_PI);
      fill(0,alpha);
      arc(0, 8, 20, 20, PI+QUARTER_PI, PI+HALF_PI+QUARTER_PI);
    }
    if(type == "health"){
      stroke(21,alpha);
      strokeWeight(1);
      noFill();
      rect(-4,-7,8,16,2);
      rect(-2,-9,4,2,2);
      noStroke();
      fill(21,21,21,128);
      rect(-4,-1,8,10,0,0,2,2);
    }
    if(type == "maxHealth"){
      noStroke();
      fill(21,alpha);
      triangle(0,-12, 6, 0, 0, 0);
      quad(0, 0, 0, -3, -5, -3, -6, 0);
      quad(0, 0, 0, 3, 5, 3, 6, 0);
      triangle(0, 12, -6, 0, 0, 0);
    }
    
    popMatrix();
  }
  
}