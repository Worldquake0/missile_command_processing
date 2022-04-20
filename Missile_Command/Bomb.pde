

/*****************************************************************************
 *
 * Class name: Bomb
 * Purpose: Bomb class which creates the bomb
 *          objects to be displayed on the screen.
 * Variables: x: This is a float for the x coordiinate of the bombs.
 *            y: This is a float for the y coordinate of the bombs.
 *            c: A color variable for the colour of the bombs.
 *
 *****************************************************************************/


private class Bomb {

  IntList bombXpos, bombYpos;
  int x, y;
  color c;
  
  private Bomb (color c) {
    this.c = c;
  }
  
  
/*****************************************************************************
 *
 * Function name: initialiseBombVariables
 * Purpose: To initalise the Integer Lists for the x and y positions of
 *          the bombs.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/

  
  void initialiseBombVariables() {
    bombXpos = new IntList(0);
    bombYpos = new IntList(0);
  }


/*****************************************************************************
 *
 * Function name: displayBomb
 * Purpose: To display bombs falling from the top of the screen. 
 *          If collisions with anti-ballistic missiles or cities 
 *          is detected, the missiles are removed. 50 points are added 
 *          for collision with anti-ballistic missile. 100 points
 *          are deducted for collision with a city. 5 points are deducted
 *          if the bombs reach the ground.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/
  
  
  void displayBomb() {
    strokeWeight(10);
    stroke(c);
    for (int i = 0; i < bombXpos.size(); i++) { 
      point(bombXpos.get(i), bombYpos.get(i));
      bombYpos.set(i, bombYpos.get(i) + bombSpeed);
      //collision detection with mountains
      if ((bombYpos.get(i) > height*0.8) || (bombYpos.get(i) > height*0.75 && 
           bombXpos.get(i) < width/20) || (bombYpos.get(i) > height*0.75 && 
           bombXpos.get(i) > width*19/20) || (bombYpos.get(i) > height*0.75 && 
           (bombXpos.get(i) > width*9/20 && bombXpos.get(i) < width*11/20))) {
        removeBomb(i);
        score -= 5;
        enemyMissilesRemaining -= 1;
      }      
      else if (bombCollision(bombXpos.get(i), bombYpos.get(i))) {
        score+=50;
        removeBomb(i);
      }  
      else if (cityCollision(bombXpos.get(i), bombYpos.get(i))) {
        removeBomb(i);
        cityCollision = append(cityCollision, 0);
        score -= 100;
        enemyMissilesRemaining -= 1;
        missileExplosionSound.rewind();
        missileExplosionSound.play();
      }
    }
  }

  
/*****************************************************************************
 *
 * Function name: createBomb
 * Purpose: To create the initial x and y coordinates for the bombs.
 *          Bombs are created randomly if the integer generated using 
 *          random() is between 996 and 1000.  
 * Arguments: n/a
 * Return: void.
 *
 *****************************************************************************/


  void createBomb() {

    if ((int)random(1000) > 995) {
      x = ((int)random(0, width));
      bombXpos.append(x);
      bombYpos.append(y);
    }
  }
  
  
/*****************************************************************************
 *
 * Function name: bombCollision
 * Purpose: To detect when the bombscollide with the anti-missiles.
 * Arguments: px: An integer for the x coordinate of the bomb
 *            py: An integer for the y cocodinat of the bomb
 * Return: true if px and py are wihin the antiMissile expanding circle.
 *         false if they are not.
 *
 *****************************************************************************/


  boolean bombCollision(int px, int py) { 
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


/*****************************************************************************
 *
 * Function name: cityCollision
 * Purpose: To detect when the bombs collide with the cities.
 *  Arguments: x: An integer for the x position of the missile.
 *            y: An integer for the y position of the missile.
 * Return: ture if the x and y coordinates of the bomb is within the
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
 * Function name: removeBomb
 * Purpose: To remove the bombs displayed on the screen.
 * Arguments: the value corrisponding to the index of the
 *             bombXpos, bombYpos Integer lists.
 * Return: void
 *
 *****************************************************************************/
  
  void removeBomb(int i) {
    bombXpos.remove(i);
    bombYpos.remove(i);
  }
}
