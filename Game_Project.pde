
Gun gun = new Gun("revolver", 100, 100, 7, 3, 12, "Assets/guns/revolver.png");

void setup() {
  fullScreen();
  noStroke();
  background(255);
  gun.display();
}






class Gun {
    // Gun class fields
    String name;
    int x, y;
    int maxBulletCount;
    int reloadTime;
    int damage;
    String gunImageFile;
    // This field is used to keep track of the current bullet count
    int currentBulletCount;

    Gun(String name, int x, int y, int maxBulletCount, int reloadTime, int damage, String gunImageFile) {
        this.name = name;
        this.x = x;
        this.y = y;
        this.maxBulletCount = maxBulletCount;
        // reload time in seconds
        this.reloadTime = reloadTime;
        this.damage = damage;
        this.gunImageFile = gunImageFile;
        this.currentBulletCount = maxBulletCount;
    }

    void display() {
      print();
        rect(x, y, 50, 50);
        image(loadImage(gunImageFile), x, y,75, 75);
    }

}
