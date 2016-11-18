/*
 *   Class used for generating bullets 
 */
class Bullet{
  
  PVector pos,vel,endPos; // Vectors for position and velocity
  String bulletType; // The string for the character that the bullet is going to be portrayed as
  int scale,diam; // The text scale and diameter used for collision detection
  boolean buzzing; // Whether or not the text should appear to "buzz" around, used for posts as they slide in to make text appear erratic
  boolean sliding; // Whether or not this letter should be sliding up and down
  int offset = (int)random(5); // Random offset for both buzzing and sliding, different for each letter
  
  /*
   *   Bullet constructor
   *   @param pos Vector   position of bullet
   *   @param vel Vector   Velocity of bullet
   *   @param bulletType   String of text for displaying bullet
   *   @param scale   Text scale
   *   @param buzzing   Determins if we start off with the bullet moving around erratically or not
   */
  Bullet(PVector pos, PVector vel, String bulletType, int scale, boolean buzzing, boolean sliding){
    this.pos = pos;
    this.vel = vel;
    this.bulletType = bulletType;
    this.scale = scale;
    this.diam = scale/4;
    this.buzzing = buzzing;
    this.sliding = sliding;
  }
  
  /*
   *   Update method, used to run standard bullet updates
   */
  void update(){
    move();
    drawMe();
  }
  
  /*
   *   Method for moving the bullet's position based on the velocity
   */
  void move(){
    pos.add(vel);
  }
  
  /*
   *   Draw method for drawing what the bullet looks like on screen
   */
  void drawMe(){
    pushMatrix();
    
    int buzzer = (int)abs(40-frameCount%80);
    int slider = (int)abs((20-offset-frameCount%40)/2)-5;
    if(buzzing)translate(pos.x+random(-buzzer,buzzer),pos.y+random(-buzzer,buzzer)); // The random elements are used to give the bullet a different position within the boundaries every frame that the bullet is marked as "buzzing"
    else if(sliding)translate(pos.x,pos.y+slider);
    else translate(pos.x,pos.y);
    
    fill(21);
    textFont((scale == 20) ? proxima20 : proxima40);
    textSize(scale);
    text(bulletType,0,0);
    
    popMatrix();
  }
  
  /*
   *   Hit detection based on a circle hit boundary
   *   @param c   Character object to check hit detection against
   */
  boolean hitCharaCircle(Chara c){
    float dx = pos.x - c.pos.x;
    float dy = pos.y - c.pos.y;
    float distance = sqrt(dx * dx + dy * dy);
    
    return distance < diam/2 + c.diam/2;
  }
  
  /*
   *   Hit detection based on a bounding box
   *   @param c   Character object to check hit detection against
   */
  boolean hitCharaBox(Chara c){    
    return c.pos.x < pos.x + diam && c.pos.x + c.w > pos.x && c.pos.y < pos.y + diam && c.pos.y + c.h > pos.y;
  }
  
}