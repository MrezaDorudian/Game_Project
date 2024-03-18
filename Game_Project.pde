import processing.sound.*;


String projectBaseURL;
PImage img;
Gun revolver, ak47, sniper;

GameController gameController;




//String backgroundSpriteAddress = "Assets/background/";
//ArrayList<PImage> backgroundImages;
PImage bg;


void setup() {
    // print processing.exe path in the computer
    projectBaseURL = sketchPath().replace("\\", "/") + "/";
    //println(projectBaseURL);
    
    
    //backgroundImages = new ArrayList<PImage>();
    //File backgroundFolder = new File(projectBaseURL + backgroundSpriteAddress);
    //File[] backgroundFiles = backgroundFolder.listFiles();
    
    //for (File file : backgroundFiles) {
    //backgroundImages.add(loadImage(file.getAbsolutePath()));
//  }
    //println(backgroundImages.size());
    bg = loadImage("Assets/background.png");
    // reduce opacity of the background image
    // bg.filter(GRAY);
    
    
    
    
    gameController = new GameController();
    noCursor();
    fullScreen();
    bg.resize(displayWidth, displayHeight);
    noStroke();
    frameRate(60);
}

void draw() {
    background(bg);
    
    // tint(255, 100);
    // image(backgroundImages.get(frameCount % backgroundImages.size()), 0, 0, displayWidth, displayHeight);
    //background(200);
    gameController.runUI();
}





static class Player {
    static int health = 40;
    static ArrayList<Integer> bullets;
    
    Player() {
        bullets = new ArrayList<Integer>();
    }
    
    static void takeDamage(int damage) {
        health -= damage;
    }
    
    boolean isGameOver() {
        if (health <= 0) {
            return true;
        } else {
            return false;
        }
    }
}






// ======================================================== GameController Class =======================================================//
class GameController {
    Player player;
    
    
    ArrayList<Enemy> enemies;
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
        
        //show current fps on the screen
        
        player = new Player();
        
        setItemsPosition();
        setGunsPosition();
        setAmmoPosition();
        setHealthPosition();
        
        
        guns = new ArrayList<Gun>();
        // add guns to the list
        
        guns.add(new Gun("revolver", gunsX.get(0), gunsY.get(0), gunsWidth, gunsHeight, 7, 14, 3, 12, true, false, "Assets/guns/revolver.png", "Assets/guns/revolver_scope.png", "Assets/guns/revolver_shot.mp3", "Assets/guns/revolver_reload.wav"));
        guns.add(new Gun("ak47", gunsX.get(1), gunsY.get(1), gunsWidth, gunsHeight, 30, 60, 3, 12, false, true, "Assets/guns/ak47.png", "Assets/guns/ak47_scope.png", "Assets/guns/ak47_shot.mp3", "Assets/guns/ak47_reload.wav"));
        guns.add(new Gun("sniper", gunsX.get(2), gunsY.get(2), gunsWidth, gunsHeight, 1, 10, 3, 999, false, false, "Assets/guns/sniper.png", "Assets/guns/sniper_scope.png", "Assets/guns/sniper_shot.mp3", "Assets/guns/sniper_reload.wav"));
        
        
        
        // add enemies to the list
        enemies = new ArrayList<Enemy>();
        
        // enemies.add(new Enemy("Assets/enemies/enemy_1/", 500, 500, 20, 10, true, "Assets/enemies/enemy_1/death.mp3"));
        
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
        fill(200, 200, 200, 200);
        rect(0, itemsY.get(0) - itemMarginY + 40, 300 , 75);
        fill(72,61,139, 100);
        rect(0, itemsY.get(0) - itemMarginY,  displayWidth, displayHeight);
        
        
        for (int i = 0; i < guns.size(); i++) {
            fill(255, 255, 255, 0);
            rect(itemsX.get(i), itemsY.get(i), itemsWidth, itemsHeight, 32);
            
            
            // display ammo count
            try{
                if (guns.get(i).isActive) {
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
                
                fill(255, 0, 0);
                textSize(maxAmmoTextSize);
                if (guns.get(i).currentBulletCount < 100) {
                    if (guns.get(i).currentBulletCount < 10) {
                        text("/" + guns.get(i).currentAmmo, ammoX.get(i) + ammoWidth + currentAmmoTextSize / 2, ammoY.get(i) + ammoHeight);
                    } else {
                        text("/" + guns.get(i).currentAmmo, ammoX.get(i) + ammoWidth + currentAmmoTextSize, ammoY.get(i) + ammoHeight);
                    }
                } else {
                    text("/" + guns.get(i).currentAmmo, ammoX.get(i) + ammoWidth + currentAmmoTextSize * 1.5, ammoY.get(i) + ammoHeight);
                }
                
            } catch(Exception e) {
            }
            
            image(loadImage(ammoImageFile), ammoX.get(i), ammoY.get(i), ammoWidth, ammoHeight);
            
            fill(0);
            textSize(20);
            
            
        }
    }
    
    void displayHealth() {
        //health bar
        fill(64);
        rect(healthBarX, healthBarY, healthBarWidth, healthBarHeight, 10);
        fill(0, 100, 0);
        // map 0 to 100 to 0 to healthBarWidth
        rect(healthBarX, healthBarY, map(player.health, 0, 100, 0, healthBarWidth), healthBarHeight, 10);
        //health image
        tint(255, 255);
        image(loadImage(healthImageFile), healthImageX, healthImageY, healthImageWidth, healthImageHeight);
        
    }
    
    void displayEnemies() {
        for (Enemy enemy : enemies) {
            enemy.display();
        }
        
        for (int i = 0; i < enemies.size(); i++) {
            if (enemies.get(i).isDead) {
                if (enemies.get(i).dropHealth) {
                    Player.health += (int) random(5, 15);
                } else if (enemies.get(i).dropAmmo) {
                    guns.get((int)random(guns.size())).currentAmmo += (int) random(2, 8);
                }
                enemies.remove(i);
            }
        }
    }
    
    void createEnemy() {
        // String List
        String[] enemyTypes = { "enemy_1_1", "enemy_1_2"};
        // Randomly select an enemy type
        String enemyType = enemyTypes[(int)random(enemyTypes.length)];
        
        int dropItemRandom = (int)random(100);
        boolean dropHealth = dropItemRandom > 0 && dropItemRandom < 10;
        boolean dropAmmo = dropItemRandom > 10 && dropItemRandom < 50;
        enemies.add(new Enemy("Assets/enemies/" + enemyType + "/",(int)random(displayWidth / 4, 3 * displayWidth / 4),(int)random(displayHeight / 4, displayHeight / 2), 20, 10, random(1) > 0.5, dropHealth, dropAmmo, "Assets/enemies/" + enemyType + "/death.mp3"));
    }
    
    
    
    void runUI() {
        if (player.isGameOver()) {
            println("Game Over");
            // display game over screen
            // display game over screen
            fill(0, 0, 0, 100);
            rect(0, 0, displayWidth, displayHeight);
            fill(255, 255, 255);
            textSize(64);
            textAlign(CENTER, CENTER);
            text("Game Over", displayWidth / 2, displayHeight / 2);
            textSize(32);
            text("Press 'R' to restart", displayWidth / 2, displayHeight / 2 + 100);
            
        } else {
            // random enemy creation based on frame
            if (frameCount % (int) random(10, 120) == 0) {
                if (random(1) > 0.3) {
                    createEnemy();
                }
            }
            
            displayItems();
            displayHealth();
            for (Gun gun : getGuns()) {
                gun.display();
            }
            displayEnemies();
            textSize(32);
            fill(0);
            text(enemies.size(), 100, 100);
        }
    }
}



//===== = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = Gun Class == = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = / /




void mousePressed() {
    
    gameController.getActiveGun().fire(gameController.enemies);
}

void mouseReleased() {
    gameController.getActiveGun().isFiring = false;
}


void keyPressed() {
    for (int i = 0; i < gameController.getGuns().size(); i++) {
        if (!gameController.getActiveGun().isReloading) {
            if (key == str(i + 1).charAt(0)) {
                if (!gameController.getActiveGun().isFiring) {
                    gameController.setActiveGun(i);
                }
            }
        }
        
    }
    if (key == 'r') {
        if (gameController.player.isGameOver()) {
            gameController.player.health = 40;
            gameController = new GameController();
        } else {
            if (!gameController.getActiveGun().isReloading && gameController.getActiveGun().currentBulletCount < gameController.getActiveGun().maxBulletCount) {
                gameController.getActiveGun().isReloading = true;
                gameController.getActiveGun().reload();
            }
        }
    }
}

// void mouseWheel(MouseEvent event) {
//   float e= event.getCount();
//   if (e >0) {
//   }
// }
