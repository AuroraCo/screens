/*
 *   Used for keyboard control
 */
float speed = 2; // Speed for character
PVector upAcc = new PVector(0, -speed); // PVector for up
PVector downAcc = new PVector(0, speed); // PVector for down
PVector leftAcc = new PVector(-speed, 0); // PVector for left
PVector rightAcc = new PVector(speed, 0); // PVector for right
boolean up, down, left, right, shoot, shootRight, shootLeft; // Booleans to keep track of movement states
void keyPressed() {
  if(key == ESC) key = 0;
  if(key == 'P' || key == 'p') paused = !paused;
  if(key == 'W' || key == 'w') up = true;
  if(key == 'S' || key == 's') down = true;
  if(key == 'A' || key == 'a') left = true;
  if(key == 'D' || key == 'd') right = true;
  if(key == ' ' && curStage == YOU_DIED) {
    resetStage(lastStage);
  }
  if(key == CODED){
    if(keyCode == RIGHT) {player.facingRight = true; shootRight = true;} // This configuration allows for constant shooting as long as an arrow key is pressed (with pressing another one overriding it)
    if(keyCode == LEFT) {player.facingRight = false; shootLeft = true;}
    if(keyCode == SHIFT){
      player.showHitbox = !player.showHitbox;
    }
    if(keyCode == UP) saveFrame("screens-###.png");
  }
}

void keyReleased() {
  if(key == 'W' || key == 'w') up = false;
  if(key == 'S' || key == 's') down = false;
  if(key == 'A' || key == 'a') left = false;
  if(key == 'D' || key == 'd') right = false;
  if(key == CODED){
    if(keyCode == RIGHT) shootRight = false; if(shootLeft) player.facingRight = false;
    if(keyCode == LEFT) shootLeft = false; if(shootRight) player.facingRight = true;
  }
}