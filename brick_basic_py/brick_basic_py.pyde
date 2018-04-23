numBricksX = 10;
numBricksY = 5;

level = 0
numLevels = 3;
ballsDropped = 0;

bricks = [numLevels][numBricksX][numBricksY]

def setup():
    size(displayWidth / 2, displayHeight / 2, P2D)
    frameRate(60)
    background(100, 149, 237)
    
def draw():
    if  mousePressed:
        fill(0)
    else:
        fill(255)
    ellipse(mouseX, mouseY, 80, 80)