/*
 *   Class used for base characters that move around
 */
class Chara{
  PVector pos,vel; // Vectors for velocity and position
  
  int health,diam,h,w; // Ints for keeping track of health, diameter, height, and width (allowing for both bounding boxes and circles)
  boolean alive = true; // For keeping track of whether a character is alive, default state
  
  /*
   *   Character constructor
   *   @param pos Vector   position of character
   *   @param vel Vector   Velocity of character
   *   @param health   Health of character
   *   @param diam   Diameter of character 
   */
  Chara(PVector pos, PVector vel, int health, int diam){
    this.health = health;
    this.diam = this.h = this.w = diam; // Sets the width and height to the diameter by default, though these are usually overriden 
    this.pos = pos;
    this.vel = vel;
  }
  
  /*
   *   Basic update method, used to run standard character updates
   */
  void update(){
    move();
    drawMe();
  }
  
  /*
   *   Method for moving the character's position based on the velocity
   */
  void move(){
    pos.add(vel);
  }
  
  /*
   *   Draw method for drawing what the character looks like on screen
   */
  void drawMe(){
    
  }
  
  /*
   *   Basic hit method for allowing the character to take damage, kill the character if health falls below 0
   *   @param damage   Used to inflict that much damage upon the character's health
   */
  void hit(int damage){
    if(alive){
      health -= damage;
      if(health <= 0) alive = false;
    }
  }
}