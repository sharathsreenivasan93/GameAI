class SteerShape {
  
  PVector char_pos;
  PVector linear;
  PVector goal_vel;
  PVector char_vel;
  PVector direction;
  float goal_speed;
  float r;
  float max_vel;
  
  SteerShape(float x, float y){
   char_pos = new PVector(x,y);
   linear = new PVector(0,0);
   goal_vel = new PVector(0,0);
   char_vel = new PVector(0,0);
   direction = new PVector(0,0);
   max_vel = 4;
   r = 5;
  }
  void steer(PVector direction){
    println(direction);
    goal_speed = 3;
    goal_vel = direction;
    goal_vel.normalize();
    goal_vel.mult(goal_speed);
    linear = PVector.sub(goal_vel,char_vel);
    update();
    }
    void update(){
      char_vel.add(linear);
      char_vel.limit(max_vel);
      char_pos.add(char_vel);
      linear.mult(0);
      borders();
    }
    void borders(){
    if (char_pos.x < -r)
      char_pos.x = width + r;
    if (char_pos.y < -r)
      char_pos.y = height + r;
    if (char_pos.x > width + r)
      char_pos.x = - r;
    if (char_pos.y > height + r)
      char_pos.y = - r;
  }
    void display() {
      float theta = char_vel.heading()-PI/2;
      fill(0);
      stroke(0);
      pushMatrix();
      translate(char_pos.x,char_pos.y);
      rotate(theta);
      beginShape();
      ellipse(0,0,2*r,2*r);
      vertex(r,0);
      vertex(-r,0);
      vertex(0,2*r);
      endShape(CLOSE);
      popMatrix();
  }
}

SteerShape shape=new SteerShape(40,40);
PVector target_direction;
int count = 0;

void setup()
{
  target_direction= new PVector(40,40);
  size(400,400);
  stroke(0,0,255);
}
void draw()
{
 background(255);
 float theta;
 if(count == 25)
 {
   theta = random(2*PI);
   target_direction= new PVector(cos(theta),sin(theta));
   count = 0;
  }
  else
  {
    count = count + 1;
  }
  shape.steer(target_direction);
  shape.display();
}