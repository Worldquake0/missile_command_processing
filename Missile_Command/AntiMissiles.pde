

/*****************************************************************************
 *
 * Class name: AntiMissiles
 * Purpose: Anti-missile class that allows the player to fire anti-missiles
 *          (ellipses that expand and detonate the incoming enemy missiles).
 *          
 * Variables: aX: This is a float for the x coordinate of where the mouse  
 *                clicks to fire anti-missiles.
 *            aY: This is a float for the y coordinate of where the mouse  
 *                clicks to fire anti-missiles.
 *            r: This is a float for the radius of the expanding circle.
 *            time: This is an integer which stores the value of millis()
 *                  when the function is called.
 *            
 * Based on code found in a Processing.org forum.
 * Site reference: https://forum.processing.org/two/discussion/8456/
 *                 create-a-line-from-point-a-to-mouseclick-coordinates
 *****************************************************************************/


private class AntiMissiles {
  float aX;
  float aY;
  float r;
  int time;
  
  public AntiMissiles(float aX, float aY, float r) {
    this.aX = aX;
    this.aY = aY;
    time = millis();
    this.r = r;
  }


/*****************************************************************************
 *
 * Function name: displayAntiMissiles
 * Purpose: To display trajectory of anti-missiles, when the trajectory
 * reaches the position where the mouse is clicked, an expanding circles
 * is displayed. Anti-missile sound is also played at the first iteration
 * of the expanding circle.
 * Arguments: n/a
 * Return: if true display Anti-missiles. 
 *
 *****************************************************************************/


  boolean displayAntiMissiles() {
    if (millis() - time < 1000) {
      stroke(0, 255, 0);
      strokeWeight(2);
      noFill();
      line(width/2, (height- (height/3.9)), lerp(width/2, aX, 
        (millis()-time)/1000.0), lerp((height-(height/3.9)), aY, 
        (millis()-time)/1000.0));  
    }
    else {
      stroke(0, 255, 0);
      strokeWeight(2);
      fill(0, 255, 0, 63);
      ellipse(aX, aY, r, r); 
      r += 1.2;
      if (r == 2.2){
        antiMissileSound.rewind();
        antiMissileSound.play();
      }
    }
    return (millis()-time > 3500);
  }
}
