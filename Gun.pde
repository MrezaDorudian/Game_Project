import processing.sound.*;

class Gun {
    // Gun class fields
    String name;
    int x, y;
    int height, width;
    int maxBulletCount;
    int currentAmmo;
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
    
    
    Gun(String name, int x, int y, int height, int width, int maxBulletCount, int currentAmmo, int reloadTime, int damage, boolean isActive, boolean isFiringAuto, String gunImageFile, String scopeImageFile, String fireSoundFile, String reloadSoundFile) {
        this.name = name;
        this.x = x;
        this.y = y;
        this.height = height;
        this.width = width;
        this.maxBulletCount = maxBulletCount;
        this.currentAmmo = currentAmmo;
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
    
    void fire(ArrayList<Enemy> enemies) {
        if (isActive) {
            if (currentBulletCount > 0) {
                isFiring = true;
                if (!isReloading) {
                    if (isFiringAuto) {
                        Thread fireThread = new Thread(new Runnable() {
                            @Override
                            public void run() {
                                while(isFiring) {
                                    if (currentBulletCount > 0) {
                                        currentBulletCount--;
                                        targetShake = maxTargetShake;
                                        fireSound.play();
                                        for (Enemy enemy : enemies) {
                                            if (enemy.colliderX < mouseX && mouseX < enemy.colliderX + enemy.colliderWidth && enemy.colliderY < mouseY && mouseY < enemy.colliderY + enemy.colliderHeight) {
                                                // If the mouse is inside the collider, then the enemy is hit
                                                enemy.hit(damage);
                                            }
                                        }
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
                        
                        for (Enemy enemy : enemies) {
                            if (enemy.colliderX < mouseX && mouseX < enemy.colliderX + enemy.colliderWidth && enemy.colliderY < mouseY && mouseY < enemy.colliderY + enemy.colliderHeight) {
                                // If the mouse is inside the collider, then the enemy is hit
                                enemy.hit(damage);
                            }
                        }
                        isFiring = false; 
                    }
                }
                
            } else if (!isReloading) {  // Check if not already reloading
                isReloading = true;
                reload();
            }
            
        }
    }
    
    void reload() {
        if (isActive) {
            if (currentAmmo > 0) {
                isFiring = false;
                reloadSound.play();
                Thread reloadThread = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            Thread.sleep(reloadTime * 1000); // Convert reload time to milliseconds
                        } catch(InterruptedException e) {
                            e.printStackTrace();
                        }
                        if  (currentAmmo - (maxBulletCount - currentBulletCount) < 0) {
                            currentBulletCount += currentAmmo;
                            currentAmmo = 0;
                        } else {
                            currentAmmo -= maxBulletCount - currentBulletCount;
                            currentBulletCount += maxBulletCount - currentBulletCount;
                        }
                        
                        
                        isReloading = false;
                    }
                });
                reloadThread.start();
            } else {
                isReloading = false;
            }
        }
    }
    
}
