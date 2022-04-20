

/*****************************************************************************
 *
 * Class name: Cities
 * Purpose: Cities class constructor which creates the city
 *          objects to be displayed on the screen.
 * Variables: x: This is a float for the x coordinate of the images.
 *            y: This is a float for the y coordinate of the images.
 *            img: used to display the initial city image.
 *            img2: used to display the destroyed city image.
 *
 *****************************************************************************/


private class Cities {

  PImage img, img2;
  float x, y;
  
  public Cities(PImage img, PImage img2, float x, float y) { 
    this.img = img;
    this.img2 = img2;
    this.x = x;
    this.y = y;
  }


/*****************************************************************************
 *
 * Function name: displayCity
 * Purpose: To display the images of the initial cities.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


  private void displayCity() {
    image(img, x, y);
  }


/*****************************************************************************
 *
 * Function name: displayDestroyedCity
 * Purpose: To display the images of the destroyed cities.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


  private void displayDestroyedCity() {
    image(img2, x, y);
  }
}
