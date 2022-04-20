

/*****************************************************************************
 *
 * Class name: EnemyMissiles
 * Purpose: 
 * Variables: missileAngles: angles of missiles fired from top of screen.
 *                           Values stored in a Float list
 *            missileStartXpos: x coordinates of missiles appearing from 
 *                              top of screen. Values stored in an 
 *                              Integer list
 *            missileYpos: y coordinates of missiles appearing on the screen.
 *                         Values stored in an Integer list
 *            ySpeed: The speed at which the missiles fall from the top of
 *                    of the screen.
 *            minSpeed: An integer used to set the minimum speed of the 
 *                      missiles.
 *            maxSpeed: An integer used to set the maximum speed of the
 *                      missiles.
 *            startX: An integer for the starting x position of the missiles.
 *            c: color variable for the missile colour.
 * 
 *****************************************************************************/


private class EnemyMissiles {
  FloatList missileAngles;
  IntList missileStartXpos, missileYpos;
  IntList ySpeed;
  final int minSpeed = 1, maxSpeed = 2;
  color c;

  public EnemyMissiles (color c) {  
    this.c = c;
  }


/*****************************************************************************
 *
 * Function name: displayEnemyMissiles
 * Purpose: To display trajectory of enemy missiles, and play sound of enemy 
 *          missile exploding when hitting the cities. If collisions with 
 *          anti-ballistic missiles or cities is detected, the missiles
 *          are removed. 50 points are added for collision with 
 *          anti-ballistic missile. 100 points are deducted for collision
 *          with a city. 5 points are deducted if the bombs reach the ground.
 *          Missiles are created randomly if the integer generated using 
 *          random() is between 995 and 1000.
 *          
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


  private void displayEnemyMissiles() {

    if ((int)random(1000) > 994) {
      missileStartXpos.append(int(random(0, width))); 
      int x = missileStartXpos.get(missileStartXpos.size()-1);
      float  minAngle = degrees(atan(float(height) / 
                        (float(width) - float(x))));
      float maxAngle = 180.0 - degrees(atan(float(height) / float(x)));
      missileAngles.append(random(minAngle, maxAngle));
      missileYpos.append(0);
      ySpeed.append(int(random(minSpeed, maxSpeed)));
    }

    for (int i=0; i<missileAngles.size(); i++) {
      int xpos = drawMissile(missileStartXpos.get(i), missileYpos.get(i), 
                    missileAngles.get(i));
      if (antiMissileCollision(xpos, missileYpos.get(i))) {
        score+=50;
        removeMissile(i);
        enemyMissilesRemaining -= 1;
      }   
      else if (cityCollision(xpos, missileYpos.get(i))) {
        removeMissile(i);
        cityCollision = append(cityCollision, 0);
        score -= 100;
        enemyMissilesRemaining -= 1;
        missileExplosionSound.rewind();
        missileExplosionSound.play();
      } 
      else {
        missileYpos.set(i, missileYpos.get(i) + ySpeed.get(i));
        // collision detection with mountains
        if ((missileYpos.get(i) > height*0.8) || 
           (missileYpos.get(i) > height*0.75 && xpos < width/20) ||
           (missileYpos.get(i) > height*0.75 && 
           xpos > width*19/20) || (missileYpos.get(i) > height*0.75 && 
           xpos > width*9/20 && xpos < width*11/20)) {
           
          removeMissile(i);
          score -= 5;
          enemyMissilesRemaining -= 1;
        }
      }
    }
  } 


/*****************************************************************************
 *
 * Function name: drawMissile
 * Purpose: To draw the enemy missiles.
 * Arguments: startX: An integer for the starting x position of the missiles.
 *            ypos: An integer for the y coordinate of the missile
 *            theta: the angle at which the missile enters the top of
 *                   the screen.
 * Return: xpos: An integer for the x coordinate used in the displayMissile
 *               function.
 *
 *****************************************************************************/


  int drawMissile(int startX, int ypos, float theta) {
    int xpos = startX + calcXpos(ypos, theta);
    stroke(c);
    strokeWeight(3);
    line(startX, 0, xpos, ypos);    
    return xpos;
  }


/*****************************************************************************
 *
 * Function name: initialiseEnemyMissileVariables
 * Purpose: To initalise the enemy missiles variables.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


  public void initialiseEnemyMissileVariables() {
    missileAngles = new FloatList(0);
    missileStartXpos = new IntList(0);
    missileYpos = new IntList(0);
    ySpeed = new IntList(0);
  }


/*****************************************************************************
 *
 * Function name: calcXpos
 * Purpose: To calculate the x position of the enemy missiles in flight.
 * Arguments: ypos: An integer for the y coordinate of the missile.
 *            theta: A float for the angle at which the missile is travlleing.
 * Return: An integer for the x coordinate of the missile based on theta.
 *
 *****************************************************************************/


  int calcXpos(int ypos, float theta) {
    return round(ypos/tan(radians(theta)));
  }


/*****************************************************************************
 *
 * Function name: cityCollision
 * Purpose: To detect when the enemy missiles collide with the cities.
 * Arguments: x: An integer for the x position of the missile.
 *            y: An integer for the y position of the missile.
 * Return: ture if the x and y coordinates of the missile is within the
 *         x and y coordinates of the city images.
 *         false if they are not.
 *
 *****************************************************************************/


  boolean cityCollision(int x, int y) {
    for (int i = 0; i < cities.length; i++) {
      if ((x >= cities[i].x && x<= cities[i].x + cityWidth) &&
        (y >=  cities[i].y && y<= cities[i].y +cityHeight)) {
        if (cityCollision[i] == 1) {
          score +=0;
        } 
        else {
          cityCollision[i] = 1;
          destroyedCityCounter ++;
          return true;
        }
      } 
      else if (y >= height) {
        return true;
      }
    }
    return false;
  }


/*****************************************************************************
 *
 * Function name: removeMissile
 * Purpose: To remove the missiles displayed on the screen.
 * Arguments: the value corrisponding to the index of the missileAngles
 *            Float list and the missileStartXpos, missileYpos and ySpeed
 *            Integer lists.
 * Return: void
 *
 *****************************************************************************/


  void removeMissile(int i) {
    missileAngles.remove(i);
    missileStartXpos.remove(i);
    missileYpos.remove(i);
    ySpeed.remove(i);
  }


/*****************************************************************************
 *
 * Function name: antiMissileCollision
 * Purpose: To detect when the enemy missiles collide with the anti-missiles.
 * Arguments: px: An integer for the x coordinate of the missile
 *            py: An integer for the y cocodinat of the missile
 * Return: true if px and py are wihin the antiMissile expanding circle.
 *         false if they are not.
 *
 *****************************************************************************/


  boolean antiMissileCollision(int px, int py) { 
    for (int i=0; i< antiMissiles.size(); i++) { 
      AntiMissiles c = (AntiMissiles)antiMissiles.get(i);
      float distX = px - c.aX;
      float distY = py - c.aY;
      float distance = sqrt( (distX*distX) + (distY*distY) );

      if (distance <= c.r/2) {
        return true;
      }
    }
    return false;
  }
}
