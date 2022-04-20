

/******************************************************************************
 *
 * Purpose: 
 * This program runs an interactive 'Missile Command' game. 
 * There are cities that sit at the bottom of the screen that are attacked by 
 * enemy projectiles falling randomly from the top of the screen. 
 * The player is in control of an anti-missile battery that fires counter-
 * missiles to intercept and destroy the enemy projectiles raining down.
 * The player controls a cross-hair that specifies where the counter-missile 
 * will detonate and when the counter-missile reaches the location, it explodes
 * leaving an expanding fireball that lasts for several seconds. 
 * All enemy projectiles that come in contact with the fireball are destroyed. 
 * There are a finite number of anti-missiles each round and once depleted, 
 * the cities are left defenceless. 
 * A score track will keep track of the number of the enemy missiles shot 
 * down, number of enemy missiles hitting the cities and the ground, 
 * and any left-over munitions at the end of a given round.
 * The level will increment up when the player survivals all of the enemy
 * missiles in each given round.
 * The number of anti-missiles the player has available resets each round.
 * When the play advances past the final level or all cities are destroyed,
 * the game will end.
 * 
 * How to Run: 
 * Press the 'Run' button.
 * At the starting menu, press 'ENTER' key to play or 'TAB' to quit.
 *
 * Controls: 
 * This game will utilise the mouse and mouse-button.
 * 
 * Sources:
 * See attached 'Sources' text file.
 * 
 ******************************************************************************/


/******************************************************************************
 *
 * Global variables:
 * 
 ******************************************************************************/

import ddf.minim.*; 

// A float which sets the gain of the audio files.
final float stdGain = -20;
// An integer which keeps track of the score, initially set to 0.
int score = 0;
// An integer for the width of the city images.
final int cityWidth = 50;
// An integer for the height of the city images.
final int cityHeight = 75;
// An integer for cursor width.
final int cursorWidth = 20;
// An integer for cursor height.
final int cursorHeight = 5;
// Colour variable for cursor.
final color cursorColour = color(255, 255, 255);
// A PImage for the image of the cities.
PImage cityImg, buildingDestroyed;
// An integer array to track the collisions of missiles to the cities.
int[] cityCollision;
// An integer for the number of cities.
int numberOfCities = 6;
// An integer to count the number of cities that are destroyed.
int destroyedCityCounter;
// An integer for the inital radius of anti-ballistic missiles.
int initialAntiMissileRadius = 1;
// Current level. 
int currentLevel = 0; 
// Max levels needed to finish game.                             
int maxLevel = 3; 
// An integer for the starting number of anti-missiles available.
int startingAmmo = 20;
// An integer for tracking the number of anti-missiles available.
int currentAmmo;
// An integer for the rate at which the bombs drop;
int bombSpeed = 1;
//A random integer for the starting x position of the bomb class.
int bombStartXpos = ((int)random(0, width));
// Max missiles each level - increases each level.
int maxEnemyMissiles = 20; 
// Total remaining that's allowed to spawn.
int enemyMissilesRemaining;    

// A PFont used for the score and ammo 
// (To try and make it look a bit retro).
PFont myFont;
// default fontSize for text displayed in the game.
int fontSize = 32;

// Missile colour not to be changed throughout the game.
final color missileColor = color(255, 255, 0);
// Bomb colour not to be changed.
final color bombColor = color(0, 0, 255);
// Mountain colour in level 1.
final color mountainColor1 = color(90, 36, 8);
// Mountain colour for level 2.
final color mountainColor2 = color(52, 50, 40);
// Mountain colour for level 3.
final color mountainColor3 = color(100, 142, 52);

// A boolean condition that is true when the game is running.
boolean gameStarted = false;

// An array to create mountains in the background.
Mountains[] mountains = new Mountains[maxLevel];
// An array to create 6 cities in the background.
Cities[] cities = new Cities[numberOfCities];

// An ArrayList for the Antimissiles class.
ArrayList<AntiMissiles> antiMissiles;
// An ArrayList for the EnemyMissiles class.
ArrayList<EnemyMissiles> enemyMissiles; 
// An ArrayList for the Bomb class.
ArrayList<Bomb> bomb;

// Create a Cursor object.
Cursor cursor;
// Initiate Minim sound player.
Minim minim;
// Create SoundFx objexts: background music, antimissile sound and 
// missile explosion sound.
SoundFx backgroundMusic, antiMissileSound, missileExplosionSound;


/*****************************************************************************
 *
 * Function name: setup
 * Purpose: To setup font, backgorund, sounds, cursor, arrays.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


void setup() {
  size(1000, 800);
  noSmooth();
  noCursor();

  myFont = loadFont("Serif.vlw");
  
  setupCities();
  setupSounds(); 
  
  cursor = new Cursor(mouseX, mouseY, cursorWidth, 
                     cursorHeight, cursorColour);
 
  mountains[0] = new Mountains(0, height, width, (height/1.25 - height), 
                 mountainColor1);
  mountains[1] = new Mountains(0, height, width, (height/1.25 - height), 
                 mountainColor2); 
  mountains[2] = new Mountains(0, height, width, (height/1.25 - height), 
                 mountainColor3);
  
  for (int i=0; i<cities.length; i++) {
    cityCollision = new int[0];
  }
  
  antiMissiles = new ArrayList();
  enemyMissiles = new ArrayList();
  enemyMissiles.add(new EnemyMissiles(missileColor));
   
  for (EnemyMissiles e : enemyMissiles) {
    e.initialiseEnemyMissileVariables();
  }

  bomb = new ArrayList();
  bomb.add(new Bomb(bombColor));
  
  for (Bomb b : bomb) {
   b.initialiseBombVariables(); 
  }
}


/*****************************************************************************
 *
 * Function name: draw
 * Purpose: To execute all functions in the program.   
 *          If the game is not started, the start screen will be displayed.
 *          If the game is started, display background, cursor, start ammo
 *          counter, score counter, game level.         
 *          If there are more than 0 enemy missiles, append enemy missiles.
 *          If a city is hit by enemy missiles, display destroyed city, 
 *          otherwise display city.
 *          Remove antimissiles from screen after they are fired.
 *          See functions for details.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


void draw() { 

  background(0);

  if (gameStarted == false) {
    startScreen();
  } 
  else if (gameStarted == true) {
    for(int i=0; i<mountains.length; i++){
      if (currentLevel == i+1){
      mountains[i].display();
     }
   }
   
    cursor.update();
    ammoCounter();
    score(); 
    gameLevel();
    
    if (enemyMissilesRemaining > 0) {
      for (EnemyMissiles e : enemyMissiles) {
        e.displayEnemyMissiles();        
      } 
    } 
    if (currentLevel >= 2){
      for(Bomb b : bomb){
        b.createBomb();
        b.displayBomb();
      }
    }       
    for (int i=0; i<cities.length; i++) {
      cityCollision = append(cityCollision, 0);
      if (cityCollision[i] == 1) {
        cities[i].displayDestroyedCity(); 
        if (destroyedCityCounter == numberOfCities) {
          endScreen();
        }
      } 
      else {
        cities[i].displayCity();
      }
    }
    for (int i=antiMissiles.size()-1; i>=0; i--) { 
      if (antiMissiles.get(i).displayAntiMissiles()) antiMissiles.remove(i);
    }     
  }
}


/*****************************************************************************
 *
 * Function name: mousePressed
 * Purpose: To fire a counter-missile and decrease the ammo count by 1.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


void mousePressed() {
  if (currentAmmo > 0 && gameStarted == true) {
    antiMissiles.add(new AntiMissiles(mouseX, mouseY, 
                    initialAntiMissileRadius));
    currentAmmo -= 1;
  }
}


/*****************************************************************************
 *
 * Function name: ammoCounter
 * Purpose: To display the number of enemy missiles and counter-missiles
 *          remaining. If counter-missile ammo is depleated, a message appears
 *          saying "Counter-missiles depleted!"
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


void ammoCounter() {
  fill(255, 200, 55, 200);
  textFont(myFont, 28);
  textAlign(CENTER);
  text("Counter-missiles remaining: " + currentAmmo, (width/2), (0.90*height));
  text("Enemy-missiles remaining: " + enemyMissilesRemaining, (width/2), 
      (0.94*height));

  if (currentAmmo == 0) {
    fill(255, 80, 80, 200);
    textFont(myFont, 50);
    text("Counter-missiles depleted!", (width/2), (0.65*height));
  }
}


/******************************************************************************
 *
 * Function name: setupSounds
 * Purpose: To load and create new instances of the audio file objects.
 * Arguments: n/a
 * Return: void
 * See attached 'Sources' text file for reference details.
 *
 ******************************************************************************/


void setupSounds() {
  backgroundMusic = new SoundFx(this, 
                    "data/your_last_game.wav", stdGain); 
  antiMissileSound = new SoundFx(this,
                     "data/anti_missile_sound.mp3", stdGain/2);
  missileExplosionSound = new SoundFx(this, 
                          "data/missile_explosion_sound.mp3", stdGain);
  
  backgroundMusic.loop();
}


/******************************************************************************
 *
 * Function name: setupCities
 * Purpose: To generate the cities for the game.
 * Arguments: n/a
 * Return: void
 * See attached 'Sources' text file for reference details.
 *
 ******************************************************************************/


void setupCities() {
  cityImg = loadImage("Pngtree_building.png");
  cityImg.resize(cityWidth, cityHeight);
  buildingDestroyed = loadImage("building_destroyed.png");
  buildingDestroyed.resize(cityWidth, cityHeight);

  for (int i = 0; i < numberOfCities; i += 1) {
    cities[i] = new Cities(cityImg, buildingDestroyed, width*(2.2*i+0.65)/13, 
    (height/1.25)-cityWidth);
  }
}


/*****************************************************************************
 *
 * Function name: score
 * Purpose: To display the player score at the top of the screen.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


void score() {
  fill(255, 0, 0);
  textFont(myFont);
  textAlign(CENTER);
  textSize(60);
  text(nf(score, 4), width/2, height/12);
}


/*****************************************************************************
 *
 * Function name: gameLevel
 * Purpose: To control and display what level the game is currently at. 
 *          When the number of enemy missiles reaches zero, the level 
 *          increases, and the number of enemy missiles and counter-missiles 
 *          replenishes. 
 *          If a player does not use all of the ammo during a level, they
 *          will be rewarded with 5 points per anti-ballistic missiles left.
 *          A statement with the bonus points will be printed to the console.
 *          If the player advances past the highest level, the game ends.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


void gameLevel() {
  fill(255, 0, 0);
  textFont(myFont);
  textSize(40);
  textAlign(LEFT);
  text("Level: " + currentLevel, width/20, height/13);

  if (enemyMissilesRemaining == 0) {  
    if (currentAmmo != 0){
     int bonusScore = currentAmmo * 5;
     score += bonusScore; 
     println("Bonus for not using all Counter missiles: "
           + bonusScore);        
    }
    
    currentLevel += 1;
    maxEnemyMissiles = 20 * currentLevel; 
    enemyMissilesRemaining = maxEnemyMissiles; 
    currentAmmo = currentAmmo + 10 + (15 * currentLevel);
    
    if (currentLevel > maxLevel) {
      endScreen();
    }
  }
}


/*****************************************************************************
 *
 * Function name: startScreen
 * Purpose: To display a screen that lets the player start the game or quit.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


void startScreen() {
  background(0);
  textAlign(CENTER);
  textFont(myFont, 90);
  text("Missile Command!", width/2, height/6);
  textSize(45);
  text("Press ENTER to start", width/2, height*0.45);
  text("Press TAB to Exit", width/2, height*0.5);
  text("How to Play:", width/2, height*0.7);
  textSize(38);
  text("Left-click to fire anti-missiles", width/2, height*0.75);

  if (keyPressed) {
    if (key == ENTER) {
      gameStarted = true;
    }
    if (key == TAB) {
      exit();
    }
  }
}


/*****************************************************************************
 *
 * Function name: endScreen
 * Purpose: To display a message to the player at the end of the game.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


void endScreen() {

  textSize(80);
  fill(255, 0, 0);
  textAlign(CENTER);

  if (destroyedCityCounter == numberOfCities) {
    text("GAME OVER", width/2, height/4);
  } 
  else if (destroyedCityCounter < numberOfCities) {
    fill(100,220,100); 
    text("Congratulations!", width/2, height/4);
    text("You win!", width/2, height/2.5);
  }
  stop();
}
