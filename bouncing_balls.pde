import KinectPV2.KJoint;
import KinectPV2.*;
import ddf.minim.*;


Minim minim;
AudioInput in;
KinectPV2 kinect;
 
int num_Balls = 60;
ball[]balls = new ball[num_Balls];
int minRadius = 2;
int maxRadius = 20;

int exist_User = 0;
 
void setup()
{
  size(1480, 900, P3D);
  background(0);
  smooth();
  noStroke();
  for(int i = 0; i < num_Balls; i++){
    float radius = random(minRadius, maxRadius);
    PVector startPosition = new PVector(random(width), random(height));
    PVector startVelocity = new PVector(random(-4, 4), random(-4, 4));
    balls[i] = new ball(startPosition, startVelocity, radius);
    balls[i].bounce = -1;
    balls[i].mass = radius / 5;
  }
  
  minim = new Minim(this);
  minim.debugOn();
  in = minim.getLineIn(Minim.STEREO, 1024);
  
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();  
}




void draw(){
  
  noStroke();
  fill(0, 5);
  rect(0,0,width,height);
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();  

//draw graphic
  for(int i = 0; i < num_Balls; i++){
    balls[i].move();
    balls[i].display();
    checkWalls(balls[i]);
    balls[i].velocity.limit(maxRadius - 0.8*balls[i].radius);
  }
  for(int i = 0; i < num_Balls - 1; i++){
    for(int j = i + 1; j < num_Balls; j++){      
      spring(balls[i], balls[j]);
    }
  }
  
//interact with Kinect
  exist_User = 0;
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      exist_User++;
      KJoint[] joints = skeleton.getJoints();

      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);

      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      //drawHandState(joints[KinectPV2.JointType_HandLeft]);
      PVector righthand = new PVector(joints[KinectPV2.JointType_HandRight].getX(), joints[KinectPV2.JointType_HandRight].getY());
      if(righthand.y > 600){
        for(int k = 0; k < num_Balls; k++){
        kickball(righthand, balls[k]);
        }
      } 
    }
  }   


//interact with music when nobody is tracked
  if(exist_User == 0){
    for(int w = 0; w< in.bufferSize() - 1; w+= 160){
      float y = abs( in.left.get(w)*height);
      float strength = random(30);
      for(int q = 0; q < num_Balls; q++ ){
        attractball( new PVector(w, y), balls[q], strength);
      }
    }
  }
  
  /*for(int i = 0; i < num_Balls; i++){
    kickball(new PVector(mouseX, mouseY), balls[i]);
  }  */
  
}




void checkWalls(ball b){
  if(b.position.x + b.radius > width)
  {
    b.position.x = width - b.radius;
    b.velocity.x *= b.bounce;
  }
  else if(b.position.x < b.radius)
  {
    b.position.x = b.radius;
    b.velocity.x *= b.bounce;
  }
  else if(b.position.y > height - b.radius)
  {
    b.position.y = height - b.radius;
    b.velocity.y *= b.bounce;
  }
  else if(b.position.y < b.radius)
  {
    b.position.y = b.radius;
    b.velocity.y *= b.bounce;
  }
}


float min_Dist = 300;
void spring(ball ballA, ball ballB)
{
  float dist = PVector.dist(ballA.position, ballB.position);   
  if(dist < min_Dist){     
    strokeWeight(1);
    stroke(255,50);
    line(ballA.position.x, ballA.position.y, ballB.position.x, ballB.position.y);
     
  }
}