class ball
{
  PVector position;
  PVector velocity;
  float radius;   
  float mass = 1.0; 
  float gravity = 0.2;
  float bounce = 1.0; 
    
  ball(PVector position, PVector velocity, float radius)
  {
    this.position = position;
    this.velocity = velocity;
    this.radius = radius;

  }
   
  void move()
  {
    velocity.y += gravity;
    position.add(velocity);
  }
   
  void display()
  {
    fill(200,40);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
}