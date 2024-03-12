import processing.sound.*;

class Enemy {
    String baseSpriteAddress;
    // animation sprites
    ArrayList<PImage> idleSprites;
    ArrayList<PImage> attackSprites;
    ArrayList<PImage> moveSprites;
    ArrayList<PImage> deathSprites;
    
    // enemy position
    int x, y;
    int currentDistance = 7000; //max distance from the player
    float speed;
    int damage;
    int health = 100;
    // enemy state
    boolean isAimedAt = false;
    boolean directionRight;
    boolean isDead = false;
    boolean isIdle = false;
    boolean castToVoid = false;
    
    float colliderX, colliderY, colliderWidth, colliderHeight;
    
    String deathSoundFile;
    SoundFile deathSound;
    
    
    Enemy(String baseSpriteAddress, int x, int y, float speed, int damage, boolean directionRight, String deathSoundFile) {
        this.baseSpriteAddress = baseSpriteAddress;
        this.x = x;
        this.y = y;
        this.colliderX = x;
        this.colliderY = y;
        this.speed = speed;
        this.damage = damage;
        this.directionRight = directionRight;
        this.deathSoundFile = deathSoundFile;
        this.deathSound = new SoundFile(Game_Project.this, deathSoundFile);
        setAnimations();
    }
    
    void hit(int damage) {
        health -= damage;
        println("Enemy health: " + health);
        if (health <= 0) {
            isDead = true;
        }
    }
    
    
    void setAnimations() {
        idleSprites = new ArrayList<PImage>();
        attackSprites = new ArrayList<PImage>();
        moveSprites = new ArrayList<PImage>();
        deathSprites = new ArrayList<PImage>();
        
        // for each animation, count the files in the folder and add them to the arraylist
        
        // print current directory
        File idleFolder = new File(projectBaseURL + baseSpriteAddress + "idle");
        File attackFolder = new File(projectBaseURL + baseSpriteAddress + "attack");
        File moveFolder = new File(projectBaseURL + baseSpriteAddress + "move");
        File deathFolder = new File(projectBaseURL + baseSpriteAddress + "death");
        
        
        
        File[] idleFiles = idleFolder.listFiles();
        File[] attackFiles = attackFolder.listFiles();
        File[] moveFiles = moveFolder.listFiles();
        File[] deathFiles = deathFolder.listFiles();
        
        for (File file : idleFiles) {
            idleSprites.add(loadImage(file.getAbsolutePath()));
        }
        for (File file : moveFiles) {
            moveSprites.add(loadImage(file.getAbsolutePath()));
        }
        for (File file : deathFiles) {
            deathSprites.add(loadImage(file.getAbsolutePath()));
        }
    }
    
    void setIdle() {
        if (colliderX < mouseX && mouseX < colliderX + colliderWidth && colliderY < mouseY && mouseY < colliderY + colliderHeight) {
            isIdle = true;
        } else {
            isIdle = false;
        }
    }
    
    void display() {
        setIdle();
        if (!castToVoid) {
            if (!isDead) {
                if (!isIdle) {
                    tint(255, 255);
                    fill(255, 0, 0);
                    if (baseSpriteAddress.indexOf("enemy_1") >= 0) {
                        colliderWidth = 1000000 / currentDistance * 0.2;
                        colliderHeight = 1000000 / currentDistance * 0.2;
                        colliderX = x - colliderWidth / 2;
                        colliderY = y + colliderHeight / 2;
                        rect(colliderX, colliderY, colliderWidth, colliderHeight);
                    } else if (baseSpriteAddress.indexOf("enemy_2") >= 0) {
                        colliderWidth = 1000000 / currentDistance * 0.2;
                        colliderHeight = 1000000 / currentDistance * 0.2;
                        colliderX = x - colliderWidth / 2;
                        colliderY = y + colliderHeight / 2;
                        rect(colliderX, colliderY, colliderWidth, colliderHeight);
                    }
                    image(moveSprites.get(frameCount % moveSprites.size()), x - 1000000 / currentDistance / 2 , y - 1000000 / currentDistance / 2, 1000000 / currentDistance, 1000000 / currentDistance);
                    currentDistance -= speed;
                } else {
                    tint(255, 255);
                    fill(255, 0, 0);
                    colliderWidth = 1000000 / currentDistance * 0.2;
                    colliderHeight = 1000000 / currentDistance * 0.2;
                    colliderX = x - colliderWidth / 2;
                    colliderY = y + colliderHeight / 2;
                    rect(colliderX, colliderY, colliderWidth, colliderHeight);
                    image(idleSprites.get(frameCount % idleSprites.size()), x - 1000000 / currentDistance / 2 , y - 1000000 / currentDistance / 2, 1000000 / currentDistance, 1000000 / currentDistance);
                    currentDistance -= 0;
                    
                }
                // Draw health bar on top of the sprite
                float healthBarWidth = 20;  // Adjust width based on health and scaling
                float healthBarHeight = 5;  // Adjust height of the health bar
                noStroke();
                fill(255, 0, 0);  // Green color for health bar
                // draw health bar with respect to the enemy scaling
                rect(x - (1000000 / currentDistance * 0.1) / 2, y - (1000000 / currentDistance * 0.2 - 20) / 2, 1000000 / currentDistance * 0.1, healthBarHeight);
                fill(0, 255, 0);  // Red color for health bar
                // map the health to the width of the health bar
                rect(x - (1000000 / currentDistance * 0.1) / 2, y - (1000000 / currentDistance * 0.2 - 20) / 2, map((float) health, 0.0, 100.0, 0.0, 1000000 / currentDistance * 0.1), healthBarHeight);
                // show  currentDistance on the screen
                if (currentDistance <= 1000) {
                    Player.takeDamage(damage);
                    castToVoid = true;
                    x = -1000000;
                    y = -1000000;
                }
            } else if (isDead) {
                tint(255, 255);
                deathSound.play();
                Thread deathAnimationThread = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        for (int i = 0; i < deathSprites.size(); i++) {
                            image(deathSprites.get(i), x - 1000000 / currentDistance / 2 , y - 1000000 / currentDistance / 2, 1000000 / currentDistance, 1000000 / currentDistance);
                            delay(30);
                        }
                        castToVoid = true;
                        x = -1000000;
                        y = -1000000;
                    } });
                deathAnimationThread.start();
                
            }
        }
    }
}

