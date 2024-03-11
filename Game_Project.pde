import processing.sound.*;


Gun revolver, ak47, sniper;

GameController gameController;
void setup() {
    gameController = new GameController();
    noCursor();
    fullScreen();
    noStroke();
    frameRate(60);
}

void draw() {
    background(200);
    gameController.runUI();
}





// ======================================================== GameController Class =======================================================//
class GameController {
    ArrayList<Gun> guns;
    int activeGunIndex = 0;
    
    // items display fields
    // minumum width and height of the items is 100. Don't make it less than that.
    ArrayList<Integer> itemsX = new ArrayList<Integer>();
    ArrayList<Integer> itemsY = new ArrayList<Integer>();
    int itemsHeight = 64;
    int itemsWidth = 80;
    int itemMarginX = 20;
    int itemMarginY = 50;
    int itemSlots = 3;
    
    // create 2 arraylists to store the x and y positions of the items
    ArrayList<Integer> gunsX = new ArrayList<Integer>();
    ArrayList<Integer> gunsY = new ArrayList<Integer>();
    int gunsHeight = 64;
    int gunsWidth = 64;
    

    // create 2 arraylists to store the x and y positions of the ammo
    ArrayList<Integer> ammoX = new ArrayList<Integer>();
    ArrayList<Integer> ammoY = new ArrayList<Integer>();
    String ammoImageFile = "Assets/ammo.png";
    int ammoHeight = 16;
    int ammoWidth = 16;
    int ammoMarginX = 20;
    int ammoMarginY = 32;
    int currentAmmoTextSize = 32;
    int maxAmmoTextSize = 18;

    // create 2 arraylists to store the x and y positions of the health
    int healthImageX;
    int healthImageY;
    String healthImageFile = "Assets/health.png";
    int healthImageHeight = 64;
    int healthImageWidth = 64;
    int healthBarX = 0;
    int healthBarY = 0;
    int healthBarHeight = 32;
    // relative to the screen width
    int healthBarWidth;

    
    
    GameController() {

      // show current fps on the screen

      



        setItemsPosition();
        setGunsPosition();
        setAmmoPosition();
        setHealthPosition();


        guns = new ArrayList<Gun>();
        // add guns to the list
        
        guns.add(new Gun("revolver", gunsX.get(0), gunsY.get(0), gunsWidth, gunsHeight, 7, 3, 12, true, false, "Assets/guns/revolver.png", "Assets/guns/revolver_scope.png", "Assets/guns/revolver_shot.mp3", "Assets/guns/revolver_reload.wav"));
        guns.add(new Gun("ak47", gunsX.get(1), gunsY.get(1), gunsWidth, gunsHeight, 30, 3, 12, false, true, "Assets/guns/ak47.png", "Assets/guns/ak47_scope.png", "Assets/guns/ak47_shot.mp3", "Assets/guns/ak47_reload.wav"));
        guns.add(new Gun("sniper", gunsX.get(2), gunsY.get(2), gunsWidth, gunsHeight, 1, 3, 12, false, false, "Assets/guns/sniper.png", "Assets/guns/sniper_scope.png", "Assets/guns/sniper_shot.mp3", "Assets/guns/sniper_reload.wav"));
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
    
    void setGunsPosition() {
        for (int i = 0; i < itemSlots; i++) {
            //guns height and width is 100. you can change it if you want.
            gunsX.add((itemsWidth + itemMarginX) * i + itemMarginX + (itemsWidth - gunsWidth) / 2);
            gunsY.add(displayHeight - itemsHeight - itemMarginY + (itemsHeight - gunsHeight) / 2);
        }
    }
    
    void setAmmoPosition() {
        for (int i = 0; i < itemSlots; i++) {
            ammoX.add((itemsWidth + itemMarginX) * i + itemMarginX + (itemsWidth - 100) / 2);
            ammoY.add(displayHeight - itemsHeight - itemMarginY + (itemsHeight - 100) / 2 + itemsHeight + ammoMarginY);
        }
    }
    
    void setItemsPosition() {
        for (int i = 0; i < itemSlots; i++) {
            itemsX.add((itemsWidth + itemMarginX) * i + itemMarginX);
            itemsY.add(displayHeight - itemsHeight - itemMarginY);
        }
    }

    void setHealthPosition() {
      healthImageX = itemsX.get(0) + (itemsWidth + itemMarginX) * itemSlots + itemMarginX;
      healthImageY = itemsY.get(0) + itemsHeight / 2 - healthImageHeight / 2;

      healthBarX = healthImageX + healthImageWidth + 10;
      healthBarY = itemsY.get(0) + itemsHeight / 2 - healthBarHeight / 2;

      healthBarWidth = displayWidth - healthBarX - itemsWidth - itemMarginX;
    }


    
    void displayItems() {
        fill(100, 100, 100, 100);
        rect(0, itemsY.get(0) - itemMarginY,  displayWidth, displayHeight);




        for (int i = 0; i < guns.size(); i++) {
            fill(255, 255, 255, 0);
            rect(itemsX.get(i), itemsY.get(i), itemsWidth, itemsHeight, 32);
            
            
            // display ammo count
            try{
                if(guns.get(i).isActive) {
                    tint(255, 255);
            } else {
                    tint(255, 45);
            }
            } catch(Exception e) {
                tint(255, 45);
            }
            
            try {
                textSize(currentAmmoTextSize);
                fill(210, 105, 30);
                text(guns.get(i).currentBulletCount, ammoX.get(i) + ammoWidth, ammoY.get(i) + ammoHeight);

                fill(0);
                textSize(maxAmmoTextSize);
                if(guns.get(i).currentBulletCount < 100) {
                   if (guns.get(i).currentBulletCount < 10) {
                        text("/"+ 999, ammoX.get(i) + ammoWidth + currentAmmoTextSize / 2, ammoY.get(i) + ammoHeight);
                } else {
                        text("/"+ 999, ammoX.get(i) + ammoWidth + currentAmmoTextSize, ammoY.get(i) + ammoHeight);
                }
            } else {
                text("/"+ 999, ammoX.get(i) + ammoWidth + currentAmmoTextSize * 1.5, ammoY.get(i) + ammoHeight);
            }
                
            } catch(Exception e) {
            }
            
            image(loadImage(ammoImageFile), ammoX.get(i), ammoY.get(i), ammoWidth, ammoHeight);
            
            fill(0);
            textSize(20);
            
            
        }
    }
    
    void displayHealth() {
      // health bar
      fill(64);
      rect(healthBarX, healthBarY, healthBarWidth, healthBarHeight, 10);
      fill(0, 100, 0);
      rect(healthBarX, healthBarY, healthBarWidth - 200, healthBarHeight, 10);
      // health image
      tint(255, 255);
      image(loadImage(healthImageFile), healthImageX, healthImageY, healthImageWidth, healthImageHeight);

    }


    void runUI() {
        displayItems();
        displayHealth();
        for (Gun gun : getGuns()) {
            gun.display();
        }
    }
}



//===== = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = Gun Class == = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = / /

class Gun {
    // Gun class fields
    String name;
    int x, y;
    int height, width;
    int maxBulletCount;
    int reloadTime;
    int damage;
    boolean isActive;
    boolean isFiringAuto;
    String gunImageFile;
    String scopeImageFile;
    String fireSoundFile;
    // This field is used tokeep track of the current bullet count
    int currentBulletCount;
    SoundFile fireSound;
    SoundFile reloadSound;
    boolean isReloading = false;
    boolean isFiring = false;
    float targetShake = 0;
    float maxTargetShake = 10;
    float shakeDecay = 0.8f;
    
    
    Gun(String name, int x, int y, int height, int width, int maxBulletCount, int reloadTime, int damage, boolean isActive, boolean isFiringAuto, String gunImageFile, String scopeImageFile, String fireSoundFile, String reloadSoundFile) {
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
        this.isFiringAuto = isFiringAuto;
        this.gunImageFile = gunImageFile;
        this.scopeImageFile = scopeImageFile;
        this.fireSoundFile = fireSoundFile;
        // set the current bullet count to the max bullet count at the begining
        this.currentBulletCount = maxBulletCount;
        this.fireSound = new SoundFile(Game_Project.this, fireSoundFile);
        this.reloadSound = new SoundFile(Game_Project.this, reloadSoundFile);
        
    }
    
    void scopeFollowMouse() {
        float shakeOffsetX = random( -targetShake, targetShake);
        float shakeOffsetY = random( -targetShake, targetShake);
        image(loadImage(scopeImageFile), mouseX - width / 4 + shakeOffsetX, mouseY - height / 4 + shakeOffsetY, width / 2, height / 2);
        targetShake *= shakeDecay;
    }
    
    void display() {
        fill(100, 100, 100, 0);
        rect(x, y, width, height);
        if (!isActive) {
            tint(255, 45);
            image(loadImage(gunImageFile), x, y, width, height);
        } else {
            tint(255, 255);
            image(loadImage(gunImageFile), x, y,width, height);
            scopeFollowMouse();
        }
    }
    
    void fire() {
        if (isActive) {
            if (currentBulletCount > 0) {
                isFiring = true;
                if (isFiringAuto) {
                    Thread fireThread = new Thread(new Runnable() {
                        @Override
                        public void run() {
                            while(isFiring) {
                                if (currentBulletCount > 0) {
                                    currentBulletCount--;
                                    targetShake = maxTargetShake;
                                    fireSound.play();
                                    try {
                                        Thread.sleep(100);
                                    } catch(InterruptedException e) {
                                        e.printStackTrace();
                                    }
                                } else {
                                    isFiring = false;
                                }
                            }
                        }
                    });
                    fireThread.start();
                } else {
                    currentBulletCount--;
                    targetShake = maxTargetShake;
                    fireSound.play();
                    isFiring = false;
                    print(currentBulletCount);
                }
                
            } else if (!isReloading) {  // Check if not already reloading
                isReloading = true;
                reload();
            }
            
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
                    } catch(InterruptedException e) {
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

void mouseReleased() {
    gameController.getActiveGun().isFiring = false;
}


void keyPressed() {
    for (int i = 0; i < gameController.getGuns().size(); i++) {
        if (key == str(i + 1).charAt(0)) {
            gameController.setActiveGun(i);
        }
}
    if (key == 'r') {
        if (!gameController.getActiveGun().isReloading && gameController.getActiveGun().currentBulletCount < gameController.getActiveGun().maxBulletCount) {
            gameController.getActiveGun().isReloading = true;
            gameController.getActiveGun().reload();
        }
    }
}

// void mouseWheel(MouseEvent event) {
//   float e = event.getCount();
//   if (e > 0) {
//   }
// }
