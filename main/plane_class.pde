class myPlane {
  bullet b;
  int health;
  boolean hit;
  int lastCount;

  myPlane() {
    // init plane position
    pPos = new PVector();
    pPos.x = 400 - pwidth/2;
    pPos.y = 800;

    // init plane size
    pSize = new PVector();
    pSize.x = pwidth;
    pSize.y = pheight;

    // init plane speed
    pSpeed = new PVector();
    pSpeed.x = 7;
    pSpeed.y = 6;

    health = 3;
    hit = false;

    lastCount = 0;
  }

  void update() {
    move(); // change position
    
    // freq: 15 -> 5
    if (frameCount % max(5, int(15-(timerSec+timerMin*60)/12)) == 0) shoot();
  }

  void display() {
    image(playerImg, pPos.x, pPos.y); // draw the plane
  }

  void move() {
    //println(key + "\n");
    //println(wpressed, apressed, spressed, dpressed);
    if (wpressed) pPos.y -= pSpeed.y;
    if (spressed) pPos.y += pSpeed.y;
    if (apressed) pPos.x -= pSpeed.x;
    if (dpressed) pPos.x += pSpeed.x;

    // Boundaries detection
    if (pPos.x + pwidth > width) pPos.x = width - pwidth;
    else if (pPos.x < 0) pPos.x = 0;
    if (pPos.y + pheight > height) pPos.y = height - pheight;
    else if (pPos.y < 100) pPos.y = 100;
  }

  void shoot() { 
    // add a bullet to the hashmap
    b = new bullet(pPos.x+pwidth/2-7, pPos.y+20, 0);
    bs.put(b, 1);
  }

  void hit() {
    // display the hit status
    tint(255, 255, 255, 126);
    image(playerImg, pPos.x, pPos.y); // draw the plane
    noTint();
  }

  int getHealth() {
    return health;
  }

  boolean getStatus() {
    return hit;
  }
}

void keyPressed() {
  // change status when key is pressed
  if (key == 'a' || keyCode == LEFT) apressed = true;
  if (key == 'd' || keyCode == RIGHT) dpressed = true;
  if (key == 'w' || keyCode == UP) wpressed = true;
  if (key == 's' || keyCode == DOWN) spressed = true;
}

void keyReleased() {
  // change status when key is released
  if (key == 'a' || keyCode == LEFT) apressed = false;
  if (key == 'd' || keyCode == RIGHT) dpressed = false;
  if (key == 'w' || keyCode == UP) wpressed = false;
  if (key == 's' || keyCode == DOWN) spressed = false;
}
