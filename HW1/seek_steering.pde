class SteerShape {
  
  PVector char_pos;
  PVector linear;
  PVector goal_vel;
  PVector char_vel;
  PVector direction;
  float max_vel;
  float r_s;
  float r_d;
  float time_to_target_vel;
  float goal_speed;
  float r;
  
  SteerShape(float x, float y){
   char_pos = new PVector(x,y);
   linear = new PVector(0,0);
   goal_vel = new PVector(0,0);
   char_vel = new PVector(0,0);
   direction = new PVector(0,0);
   max_vel = 2;
   r_s = 20;
   r_d = 80;
   time_to_target_vel = 3;
   r = 5;
  }
  void steer(PVector target_pos){
    float distance;
    println(target_pos);
    println(char_pos);
    direction = PVector.sub(target_pos,char_pos);
    distance = sqrt(pow((target_pos.x-char_pos.x),2) + pow((target_pos.y-char_pos.y),2));
    if (distance < r_s)
    {
      linear = char_vel.mult(-1);
      linear = linear.mult(1/time_to_target_vel);
      //linear = (char_vel*(-1))/time_to_target_vel;
    }
    if (distance > r_d)
      goal_speed = max_vel;
    
    else
      goal_speed = (max_vel*distance)/r_d;
     goal_vel = direction;
     goal_vel.normalize();
     goal_vel.mult(goal_speed);
     linear = PVector.sub(goal_vel,char_vel);
     //linear /= time_to_target_vel;
     update();
    }
    void update(){
      char_vel.add(linear);
      char_vel.limit(max_vel);
      char_pos.add(char_vel);
      linear.mult(0);
    }
    void display() {
      float theta = char_vel.heading()-PI/2;
      fill(0);
      stroke(0);
      ellipse(target_pos.x,target_pos.y,r_s,r_s);
      //triangle(target_pos.x,target_pos.y-r_s,target_pos.x,target_pos.y+r_s,target_pos.x+50,target_pos.y);
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
PVector target_pos;

void setup()
{
  target_pos= new PVector(40,40);
  size(400,400);
  stroke(0,0,255);
}
void draw()
{
 background(255);
 if(mousePressed)
 {
   target_pos= new PVector(mouseX,mouseY);
 }
 background(255);
 shape.steer(target_pos);
 shape.display();
}