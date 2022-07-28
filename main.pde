import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import processing.sound.*;

// declare player object and its relevant info
// I made them global for easier acess
myPlane player;
PVector pPos;
PVector pSpeed;
PVector pSize;
int pwidth = 80, pheight = 66;

// declare hashmap for storing bullet, enemy info
// Iterator is used when modifying hashmap while looping
HashMap<bullet, Integer> bs; // declare a hashmap for many bullets (in order to use remove() func)
HashMap<enemy, Integer> es;  // declare a hashmap for many enemies (in order to use remove() func)
HashMap<bullet, Integer> enemyBullets;
Iterator<bullet> enemyBiter;
Iterator<bullet> biter;
Iterator<enemy> eiter;

// declare relevant variables for the game
int newEnemyType;
float newEnemyX;
int tmpStatus;
int gameStage;
int score;
int addedHealth;
int startStage;
int startTimer;
int timerSec;
int timerMin;
String ttSec;
String ttMin;

// delcare boolean values for detecting the moving status
// Ensure a smoother movement
boolean apressed;
boolean wpressed;
boolean spressed;
boolean dpressed;

// Declare variables for resources: image, font, sound
PImage playerImg;
PImage enemy1Img;
PImage enemy2Img;
PImage enemy3Img;
PImage bossImg;
PImage startBg;
PImage startButton;
PImage helpButton;
PImage backButton;
PImage retryButton;
PImage mainButton;
PImage wasd;
PImage udlr;
PFont gameTitle;
PFont description;
SoundFile selectAudio;
SoundFile bgLoop;
SoundFile crashAudio;
SoundFile levelUp;
SoundFile hitAudio;

void setup() {
  size(700, 950); // window
  background(0, 0, 0);
  player = new myPlane();
  frameRate(60);

  noStroke();

  // init game stage and relevant variables
  gameStage = 0;  // 0: click to start; 1: normal game; 2: game over
  startStage = 0; // 0: start + help; 1: Back
  score = 0;
  addedHealth = 0;
  apressed = false;
  wpressed = false;
  spressed = false;
  dpressed = false;

  // init the bullet hashmap
  bs = new HashMap<bullet, Integer>();
  es = new HashMap<enemy, Integer>();
  enemyBullets = new HashMap<bullet, Integer>();

  // load images
  playerImg = loadImage("my_plane.png");
  enemy1Img = loadImage("enemy1_img.png");
  enemy2Img = loadImage("enemy2_img.png");
  enemy3Img = loadImage("enemy3_img.png");
  //bossImg = loadImage("bossImg.png");
  startBg = loadImage("start_bg.png");
  startButton = loadImage("start_button.png");
  helpButton = loadImage("help_button.png");
  backButton = loadImage("back_button.png");
  retryButton = loadImage("retry_button.png");
  mainButton = loadImage("main_button.png");
  wasd = loadImage("wasd.png");
  udlr = loadImage("udlr.png");
  gameTitle = createFont("Need for Font.ttf", 90);
  description = createFont("orange juice 2.0.ttf", 25);

  // load audios
  selectAudio = new SoundFile(this, "select_audio.wav");
  bgLoop = new SoundFile(this, "bg_loop.mp3");
  crashAudio = new SoundFile(this, "crash.mp3");
  levelUp = new SoundFile(this, "level_up.wav");
  hitAudio = new SoundFile(this, "hit.wav");
  crashAudio.amp(0.2);
  bgLoop.amp(0.3);
  levelUp.amp(0.5);
  hitAudio.amp(0.7);
}


void draw() {
  if (gameStage == 0) {
    image(startBg, 0, 0, width, height);
    fill(255, 255, 255);
    textFont(gameTitle);
    text("Air Fight", 50, 250);

    if (startStage == 0) { // initial window
      image(startButton, 150, 450, 400, 230);
      image(helpButton, 150, 600, 400, 230);

      // To make the highlight-when-selected effect
      if (mouseX > 200 && mouseX < 500 && mouseY > 500 && mouseY < 600) {
        tint(0, 255, 255, 255);
        image(startButton, 150, 450, 400, 230);
        noTint();
      }
      if (mouseX > 200 && mouseX < 500 && mouseY > 670 && mouseY < 800) {
        tint(0, 255, 255, 255);
        image(helpButton, 150, 600, 400, 230);
        noTint();
      }
    } else {
      // help window setup
      image(backButton, 150, 750, 400, 230);
      fill(240, 240, 240);
      rect(50, 300, 600, 450);
      
      // desctribe the different planes
      textFont(description);
      image(enemy1Img, 100, 320, 100, 100);
      image(enemy2Img, 290, 330, 100, 90);
      image(enemy3Img, 460, 290, 150, 150);
      fill(0, 0, 0);
      textSize(27);
      text("Noramal type", 80, 470);
      text("Speed type", 280, 470);
      text("Health type", 480, 470);
      
      // describe the keyboard action
      image(wasd, 80, 500, 220, 180);
      image(udlr, 350, 500, 300, 180);
      
      // To make the highlight-when-selected effect
      if (mouseX > 200 && mouseX < 500 && mouseY > 820 && mouseY < 950) {
        tint(0, 255, 255, 255);
        image(backButton, 150, 750, 400, 230);
        noTint();
      }
    }
  } else if (gameStage == 1) { // main loop for playing
    background(0, 0, 0);
    textFont(gameTitle);
    fill(201, 201, 201);
    rect(0, 0, width, 100);

    // Calculate and display the timer
    if (second() != startTimer) {
      timerSec++;
      startTimer = second();
      if (timerSec == 60) {
        timerSec = 0;
        timerMin++;
      }
    }
    ttSec = nf(timerSec, 2);
    ttMin = nf(timerMin, 2);
    fill(255, 0, 0);
    textSize(20);
    text("Timer:", 230, 40);
    textSize(50);
    text(ttMin + ':' + ttSec, 220, 80);

    // Display the score
    fill(0, 255, 0);
    textSize(20);
    text("Score:", 460, 40);
    textSize(50);
    text(nf(score, 5), 450, 80);

    // Display the health
    image(playerImg, 40, 10, 40, 40);
    textSize(25);
    text(" X " + nf(player.getHealth(), 2), 75, 40);
    fill(255, 0, 0);
    textSize(15);
    text("+1 / 100 scores", 30, 70);

    // Continue the game when player still has health
    if (player.getHealth() > 0) {
      // Update and display the player plane
      // check if palyer is hit by: 1). enemy; 2). bullet; 3). bonus
      player.update();
      if (player.getStatus()) {
        // if hit: hit status to true, and become invisible for 100 frames (1.5s)
        if (frameCount-player.lastCount <= 90) {
          player.hit();
        } else {
          player.hit = false;
          player.display();
        }
      } else {
        player.display();
      }

      // Update and display the enemy or BOSS
      // Amount and position are random
      // Should be harder as time goes on
      if (frameCount % max(5, int(90-(timerSec+timerMin*60)/2)) == 0) {
        newEnemyType = int(random(0, 3));
        newEnemyX = random(0, width-20);
        enemy newEnemy = new enemy(newEnemyType, newEnemyX, 100);
        es.put(newEnemy, 1);
        if (max(5, int(90-(timerSec+timerMin*60)/2)) <= 75) {
          newEnemyType = 1;
          newEnemyX = random(10, width-20);
          newEnemy = new enemy(newEnemyType, newEnemyX, 100);
          es.put(newEnemy, 1);
        }
        if (max(5, int(90-(timerSec+timerMin*60)/2)) <= 60) {
          newEnemyType = 0;
          newEnemyX = random(10, width-20);
          newEnemy = new enemy(newEnemyType, newEnemyX, 100);
          es.put(newEnemy, 1);
        }
        if (max(5, int(90-(timerSec+timerMin*60)/2)) <= 45) {
          newEnemyType = 2;
          newEnemyX = random(10, width-20);
          newEnemy = new enemy(newEnemyType, newEnemyX, 100);
          es.put(newEnemy, 1);
        }
      }

      // Update and display the player bullets
      biter = bs.keySet().iterator();
      while (biter.hasNext()) {
        bullet bb = biter.next();
        bb.update();
        bb.check();
        if (bb.getStatus()) biter.remove();
        else {
          bb.display();
        }
      }

      // Update and display the enemies
      eiter = es.keySet().iterator();
      while (eiter.hasNext()) {
        enemy ee = eiter.next();
        ee.update();
        ee.check();
        tmpStatus = ee.getStatus();
        if (tmpStatus == 1) {
          //println("enemy hits the boundary");
          eiter.remove();
        } else if (tmpStatus == 2) {
          //println("enemy hits the player bullet");
          ee.hit();
          tmpStatus = 0;
          ee.crash = 0;
        } else if (tmpStatus == 3) {
          //println("enemy is killed by the bullet");
          crashAudio.play();
          eiter.remove();
        } else {
          if (ee.lastHit != -1 && frameCount - ee.lastHit < 5) {
            //println("What's up");
            ee.hit();
          } else {
            ee.display();
            ee.lastHit = -1;
          }
        }
      }

      // Update and display the enemy bullet
      enemyBiter = enemyBullets.keySet().iterator();
      while (enemyBiter.hasNext()) {
        bullet bb = enemyBiter.next();
        bb.update();
        if (bb.getStatus()) enemyBiter.remove();
        else {
          bb.display();
        }
      }
    } else {
      // Game Over Window
      gameStage = 2;
      bgLoop.stop();
    }
  } else if (gameStage == 2) { // game over window
    // setup the bg_color and bg_image
    background(255, 255, 255);
    tint(255, 255, 255, 164);
    image(startBg, 0, 0, width, height);
    fill(201, 201, 201);
    rect(100, 100, 500, 800);
    noTint();

    // Display the final score
    fill(0, 0, 0);
    textSize(45);
    text("Your Score:", 150, 250);
    fill(0, 255, 0);
    textSize(60);
    text(nf(score, 5), 210, 350);

    // Display the final survival time
    fill(0, 0, 0);
    textSize(45);
    text("Your Time:", 170, 500);
    fill(0, 255, 0);
    textSize(60);
    text(ttMin + ':' + ttSec, 220, 600);

    // Click to replay the game
    image(retryButton, 150, 650, 400, 100);
    image(mainButton, 150, 750, 400, 100);
    if (mouseX > 150 && mouseX < 550 && mouseY > 650 && mouseY < 750) {
      tint(0, 255, 255, 255);
      image(retryButton, 150, 650, 400, 100);
      noTint();
    }
    
    if (mouseX > 150 && mouseX < 550 && mouseY > 750 && mouseY < 850) {
      tint(0, 255, 255, 255);
      image(mainButton, 150, 750, 400, 100);
      noTint();
    }
  }
}

// Function for the buttons
void mouseClicked() {
  if (gameStage == 0 && startStage == 0) {
    if (mouseX > 200 && mouseX < 500 && mouseY > 500 && mouseY < 600) {
      setup();
      gameStage = 1;
      selectAudio.play();
      delay(1000);
      bgLoop.loop();
      startTimer = second();
      timerSec = 0;
      timerMin = 0;
    }

    if (mouseX > 200 && mouseX < 500 && mouseY > 670 && mouseY < 800) {
      startStage = 1;
      selectAudio.play();
    }
  } else if (gameStage == 0 && startStage == 1) {
    if (mouseX > 200 && mouseX < 500 && mouseY > 770 && mouseY < 900) {
      startStage = 0;
      selectAudio.play();
    }
  } else if (gameStage == 2 && player.getHealth() == 0) {
    if (mouseX > 150 && mouseX < 550 && mouseY > 650 && mouseY < 780) {
      setup();
      gameStage = 1;
      selectAudio.play();
      delay(1000);
      bgLoop.loop();
      startTimer = second();
      timerSec = 0;
      timerMin = 0;
    }
    
    if (mouseX > 150 && mouseX < 550 && mouseY > 750 && mouseY < 850) {
      gameStage = 0;
      selectAudio.play();
    }
  }
}

// Simple function for checking the collision
// Global since many are involved:
// Player-enemy; Player_bullet-enemy; Player-enemy_bullet
boolean overLap(PVector pos, PVector size, PVector pPos, PVector pSize) {
  if (pos.x >= pPos.x + pSize.x || pPos.x >= pos.x + size.x ) return false;
  if (pos.y + size.y <= pPos.y || pPos.y + pSize.y <= pos.y) return false;
  return true;
}
