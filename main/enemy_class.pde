class enemy {
  PVector pos;
  PVector size;
  float speed;
  int crash;
  int health;
  int myType;
  int shootFreq;
  int lastHit;
  int showup;
  bullet b;

  enemy(int etype, float x, float y) {
    pos = new PVector();
    pos.x = x;
    pos.y = y;

    size = new PVector();

    crash = 0;  // 0: safe; 1: boudary; 2: hit; 3: die;

    myType = etype;
    if (myType == 0) {  // mormal type
      health = 3 + int((timerSec+timerMin*60)/60);
      speed = 4 + min(2, int((timerSec+timerMin*60)/60));
      shootFreq = 90;
      size.x = 80;
      size.y = 60;
    } else if (myType == 1) { // speed type
      health = 1 + int((timerSec+timerMin*60)/60);
      speed = 6 + min(2, int((timerSec+timerMin*60)/60));
      shootFreq = 105;
      size.x = 80;
      size.y = 80;
    } else {  // health type
      health = 5 + int((timerSec+timerMin*60)/60);
      speed = 2 + min(2, int((timerSec+timerMin*60)/60));
      shootFreq = 105;
      size.x = 100;
      size.y = 80;
    }

    lastHit = -1;
    showup = frameCount;
  }


  void update() {
    // update the position and shoot a bullet regarding frequency
    pos.y += speed;
    if (pos.y + 20 >= height) {
      crash = 1;
    }
    if (myType != 1 && (frameCount - showup) % shootFreq == 0) shoot();
  }

  void display() {
    // display the normal status
    if (myType == 0) {
      image(enemy1Img, pos.x, pos.y, size.x, size.y);
    } else if (myType == 1) {
      image(enemy2Img, pos.x, pos.y, size.x, size.y);
    } else {
      image(enemy3Img, pos.x, pos.y, size.x, size.y);
    }
  }

  void hit() {
    // display the hit status
    tint(255, 255, 255, 126);
    if (myType == 0) image(enemy1Img, pos.x, pos.y, size.x, size.y);
    else if (myType == 1) image(enemy2Img, pos.x, pos.y, size.x, size.y);
    else image(enemy3Img, pos.x, pos.y, size.x, size.y);
    noTint();
  }

  void check() {
    // check collision with player
    // change
    //println(overLap(pos, size, pPos, pSize));
    checkHelperE(overLap(pos, size, pPos, pSize));

    biter = enemyBullets.keySet().iterator();
    while (biter.hasNext()) {
      bullet bb = biter.next();
      checkHelperE(overLap(bb.pos, bb.size, pPos, pSize));
    }
  }

  void checkHelperE(boolean ifOverlap) {
    // check if enemy plane hits the player plane
    if (ifOverlap) {
      if (!player.getStatus()) {
        player.health--;
        //println(player.getHealth());
        player.lastCount = frameCount;
        player.hit = true;
        hitAudio.play();
      } else if (frameCount-player.lastCount > 100) {
        player.health--;
        player.lastCount = frameCount;
      } else {
        player.hit = true;
      }
    }
  }

  void shoot() {
    // enemy shoot a bullet
    b = new bullet(pos.x+size.x/2-5, pos.y+size.y-10, 1);
    enemyBullets.put(b, 1);
  }

  int getStatus() {
    return crash;
  }

  int getHealth() {
    return health;
  }
}
