Flock flock;

class Flock {
  ArrayList<Boid> boids;
  
  Flock(){
    boids = new ArrayList<Boid>();
  }
  
  void run(){
    for (Boid b : boids){
      b.run(boids);
    }
  }
  void addBoid(Boid b){
    boids.add(b);
  }
}

class Boid {
  PVector char_pos;
  PVector char_vel;
  PVector linear;
  float r;
  float max_force;
  float max_vel;
  int lead;
  
  Boid(float x, float y){
    linear = new PVector(0,0);
    float angle = random(TWO_PI);
    char_vel = new PVector(cos(angle),sin(angle));
    if (flag == 0){
      lead = 1;
      flag = 1;
    }
    else{
      lead = 0;
    }
    char_pos = new PVector(x, y);
    r = 4.0;
    max_vel = 3;
    max_force = 0.05;
  }
  
  void run(ArrayList<Boid> boids){
    flock(boids);
    update();
    borders();
    render();
  }
  
  void add_accel(PVector force) {
    linear.add(force);
  }
  
  
  void flock(ArrayList<Boid> boids){
    PVector coh = cohesion(boids);
    PVector sep = separate(boids);
    PVector ali = vel_match(boids);
    sep.mult(1.4);
    ali.mult(1.2);
    coh.mult(1.0);
    add_accel(sep);
    add_accel(ali);
    add_accel(coh);
  }
  
  void update(){
    char_vel.add(linear);
    char_vel.limit(max_vel);
    char_pos.add(char_vel);
    linear.mult(0);
  }
  
  PVector seek(PVector target){
    PVector des = PVector.sub(target, char_pos);
    des.normalize();
    des.mult(max_vel);
    
    PVector steer = PVector.sub(des, char_vel);
    steer.limit(max_force);
    return steer;
  }
  
  void render(){
    float theta = char_vel.heading() - PI/2;
    if (lead == 1){
      fill(0,0,255);
      stroke(0,0,255);
    }
    else{
      fill(0);
      stroke(0);
    }
    
    pushMatrix();
    translate(char_pos.x,char_pos.y);
    rotate(theta);
    beginShape(TRIANGLES);
    ellipse(0,0,2*r,2*r);
    vertex(r,0);
    vertex(-r,0);
    vertex(0,2*r);
    endShape();
    popMatrix();
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
  
  PVector separate(ArrayList<Boid> boids){
    float desiredseparation = 25.0;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    for (Boid other:boids){
      float d = PVector.dist(char_pos, other.char_pos);
      if ((d>0) && (d < desiredseparation)){
        PVector diff = PVector.sub(char_pos, other.char_pos);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0){
      steer.div((float)count);
    }
    if (steer.mag() > 0){
      steer.normalize();
      steer.mult(max_vel);
      steer.sub(char_vel);
      steer.limit(max_force);
    }
    return steer;
  }
  
  PVector vel_match(ArrayList<Boid> boids){
    float neighbordist = 25.0;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Boid other:boids) {
      float dist = PVector.dist(char_pos,other.char_pos);
      if ((dist>0) && (dist < neighbordist)){
        sum.add(other.char_vel);
        count++;
      }
    }
    if (count > 0){
      sum.div((float)count);
      sum.normalize();
      sum.mult(max_vel);
      PVector steer = PVector.sub(sum,char_vel);
      steer.limit(max_force);
      return steer;
    }
    else {
      return new PVector(0,0);
    }
  }
  PVector cohesion (ArrayList<Boid> boids){
    float neighbordist = 25.0;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Boid other:boids){
      float d = PVector.dist(char_pos,other.char_pos);
      if ((d>0) && (d < neighbordist)){
        sum.add(other.char_pos);
        count++;
      }
    }
    if (count > 0){
      sum.div(count);
      if (lead == 1)
        return seek(sum);
      else
        return seek(boids.get(0).char_pos);
    }
    else
      return new PVector(0,0);
  }
}

int flag = 0;

void setup(){
  size(400,400);
  flock = new Flock();
  for (int i = 0; i < 50; i++) {
    flock.addBoid(new Boid(width/2, height/2));
  }
}

void draw(){
  background(200);
  flock.run();
}