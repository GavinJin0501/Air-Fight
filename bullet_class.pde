class bullet {
  PVector pos;
  PVector size;
  float speed;
  boolean hit;
  int btype;

  bullet(float x, float y, int tt) {
    //img = loadImage(imgName);

    // init bullet position
    pos = new PVector();
    pos.x = x;
    pos.y = y;

    // init bullet size
    size = new PVector();
    size.x = 10;
    size.y = 25;

    // init bullet speed
    speed = 10;

    // init hit status
    hit = false;

    // init bullet type: player bullet=0, enemy bullet = 1;
    btype = tt;
  }

  void update() {
    if (btype == 0) {
      pos.y -= speed;
      if (pos.y <= 100) hit = true;
    } else {
      pos.y += speed;
      if (pos.y >= height) hit = true;
    }
  }

  void display() {
    // display the bullet
    // red for enemy bullet
    // green for player bullet
    if (btype == 0) fill(0, 255, 0);
    else fill(255, 0, 0);
    rect(pos.x, pos.y, size.x, size.y);
  }

  void check() {
    // check if plane bullet hits the enemy
    eiter = es.keySet().iterator();
    while (eiter.hasNext()) {
      enemy ee = eiter.next();
      if (overLap(ee.pos, ee.size, pos, size)) {
        ee.health--;
        ee.lastHit = frameCount;
        ee.crash = (ee.health > 0) ? 2 : 3;
        score = (ee.health > 0) ? score + 1 : score + 5;
        if (int(score / 100) > addedHealth) {
          player.health++;
          addedHealth++;
          levelUp.play();
        }
        hit = true;
        break;
      }
    }
  }

  boolean getStatus() {
    return hit;
  }
}
