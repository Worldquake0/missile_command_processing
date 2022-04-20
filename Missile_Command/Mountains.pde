

/*****************************************************************************
 *
 * Class name: Mountains
 * Purpose: 
 *          
 * Variables: x: A float for the x coordinate of the main (bottom) rectangle.
 *            y: A float for the y coordinate of the main (bottom) rectangle.
 *            w: A float for the width of the main (bottom) rectangle.
 *            h: A float for the height of the main (bottom) rectangle.
 *            c: A colour variable for the mountains.
 *
 *****************************************************************************/


private class Mountains {
  float x, y, w, h;
  color c;
  
  public Mountains(float x, float y, float w, float h, color c) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
  }


/*****************************************************************************
 *
 * Function name: display
 * Purpose: To display the mountains which are made up of multiple rectangles
 *          joined together.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


  void display() {
    fill(c); 
    noStroke();
    rect(x, y, w, h);  
    rect(x, y+h, w/18, h/5);
    rect(width-w/18, y+h, w/18, h/5);
    rect(width/2- width/18, y+h, w/9, h/12);
    rect(width/2- width/24, y+(h+h/12), w/9*3/4, h/12);
    rect(width/2- width/50, y+(h+(h/12)*2), w/9*3/8, h/12);
  }
}
