import processing.sound.*;


Gun revolver, ak47, sniper;

GameController gameController;
void setup() {
  gameController = new GameController();
  println(gameController.getActiveGun().name);
  noCursor();
  fullScreen();
  noStroke();
  background(255);
}

void draw() {
  background(190);
  for (Gun gun : gameController.getGuns()) {
    gun.display();
  }
}





// ======================================================== GameController Class =======================================================//
class GameController {
  ArrayList<Gun> guns;
  int activeGunIndex = 0;
  GameController() {
    guns = new ArrayList<Gun>();
    // Add guns to the list
    guns.add(new Gun("revolver", 100, 100, 100, 100, 7, 3, 12, true, "Assets/guns/revolver.png", "Assets/guns/revolver_scope.png", "Assets/guns/revolver_shot.mp3", "Assets/guns/revolver_reload.wav"));
    guns.add(new Gun("ak47", 200, 100, 100, 100, 30, 3, 12, false, "Assets/guns/ak47.png", "Assets/guns/ak47_scope.png", "Assets/guns/ak47_shot.mp3", "Assets/guns/ak47_reload.wav"));
    guns.add(new Gun("sniper", 300, 100, 100, 100, 1, 3, 12, false, "Assets/guns/sniper.png", "Assets/guns/sniper_scope.png", "Assets/guns/sniper_shot.mp3", "Assets/guns/sniper_reload.wav"));
  }

  ArrayList<Gun> getGuns() {
    return guns;
  }

  Gun getActiveGun() {
    return guns.get(activeGunIndex);
  }

  void setActiveGun(int index) {
    activeGunIndex = index;
    for (int i = 0; i < guns.size(); i++) {
      if (i == index) {
        guns.get(i).isActive = true;
      } else {
        guns.get(i).isActive = false;
      }
    }
  }
}




//======================================================= Gun Class =======================================================//





class Gun {
    // Gun class fields
    String name;
    int x, y;
    int height, width;
    int maxBulletCount;
    int reloadTime;
    int damage;
    boolean isActive;
    String gunImageFile;
    String scopeImageFile;
    String fireSoundFile;
    // This field is used to keep track of the current bullet count
    int currentBulletCount;
    SoundFile fireSound;
    SoundFile reloadSound;
    boolean isReloading = false;
    float targetShake = 0;
    float maxTargetShake = 10;
    float shakeDecay = 0.8f;
    
    Gun(String name, int x, int y, int height, int width, int maxBulletCount, int reloadTime, int damage, boolean isActive, String gunImageFile, String scopeImageFile, String fireSoundFile, String reloadSoundFile) {
        this.name = name;
        this.x = x;
        this.y = y;
        this.height = height;
        this.width = width;
        this.maxBulletCount = maxBulletCount;
        // reload time in seconds
        this.reloadTime = reloadTime;
        this.damage = damage;
        this.isActive = isActive;
        this.gunImageFile = gunImageFile;
        this.scopeImageFile = scopeImageFile;
        this.fireSoundFile = fireSoundFile;
        // set the current bullet count to the max bullet count at the begining
        this.currentBulletCount = maxBulletCount;
        this.fireSound = new SoundFile(Game_Project.this, fireSoundFile);
        this.reloadSound = new SoundFile(Game_Project.this, reloadSoundFile);
        
    }

    void scopeFollowMouse() {
        float shakeOffsetX = random(-targetShake, targetShake);
        float shakeOffsetY = random(-targetShake, targetShake);
        image(loadImage(scopeImageFile), mouseX - width / 4 + shakeOffsetX, mouseY - height / 4 + shakeOffsetY, width / 2, height / 2);
        targetShake *= shakeDecay;
    }

    void display() {
      fill(100);
        rect(x, y, width, height);
        if (!isActive) {
            tint(255, 45);
            image(loadImage(gunImageFile), x, y, width, height);
        } else {
          tint(255, 255);
          image(loadImage(gunImageFile), x, y, width, height);
          scopeFollowMouse();
        }
    }

    void fire() {
      if (isActive) {
        if (currentBulletCount > 0) {
            currentBulletCount--;
            targetShake = maxTargetShake;
            fireSound.play();
        } else if (!isReloading) {  // Check if not already reloading
            isReloading = true;
            reload();
          }
          print(currentBulletCount);
      }
    }

    void reload() {
      if (isActive) {
        reloadSound.play();


        Thread reloadThread = new Thread(new Runnable() {
          @Override
          public void run() {
            try {
              Thread.sleep(reloadTime * 1000); // Convert reload time to milliseconds
            } catch (InterruptedException e) {
              e.printStackTrace();
            }
            currentBulletCount = maxBulletCount;
            isReloading = false;
          }
        });
        reloadThread.start();
      }
    }

}


void mousePressed() {
  gameController.getActiveGun().fire();
}

void keyPressed() {
  if (key == '1') {
    gameController.setActiveGun(0);
  } else if (key == '2') {
    gameController.setActiveGun(1);
  } else if (key == '3') {
    gameController.setActiveGun(2);
  }
}


// void mouseWheel(MouseEvent event) {
//   float e = event.getCount();
//   if (e > 0) {
//   }
// }
