

/*****************************************************************************
 *
 * Class name: Cursor
 * Purpose: Cursor class constructor which initialises and displays a 
 *          rectangle to indicate the mouse/cursor location.
 * Variables: mX: This is a float for the x coordinate of the cursor.
 *            mY: This is a float for the y coordinate of the cursor.
 *            w: This is a float for the width of the cursor.
 *            h: This is a float for the height of the cursor.
 *            c: This is the color variable of the cursor.
 * 
 *****************************************************************************/


private class Cursor {
  int mX, mY, w, h;
  color c;
  
  public Cursor(int mX, int mY, int w, int h, color c) { 
    this.mX = mX;
    this.mY = mY;
    this.w = w;
    this.h = h;
    this.c = c;
  }


/*****************************************************************************
 *
 * Function name: update
 * Purpose: To display a rectangle that represents the crosshair/mouse cursor.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


  private void update() {
    mX = mouseX - 8;
    mY = mouseY - 3;
    noStroke();
    fill(c);
    rect(mX, mY, w, h);
  }
}
