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
    //println(target_pos);
    //println(char_pos);
    direction = PVector.sub(target_pos,char_pos);
    distance = sqrt(pow((target_pos.x-char_pos.x),2) + pow((target_pos.y-char_pos.y),2));
    //println("Distance"+distance);
    if (distance < r_s)
    {
      linear = char_vel.mult(-1);
      linear = linear.mult(1/time_to_target_vel);
      path_counter = path_counter + 1;
      //println("Path Counter"+path_counter);
    }
    if (distance > r_d)
      goal_speed = max_vel;
    
    else
      goal_speed = (max_vel*distance)/r_d;
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
    }
    void display() {
      float theta = char_vel.heading()-PI/2;
      fill(0);
      stroke(0);
      //ellipse(target_pos.x,target_pos.y,10,10);
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

void setup()
{
  target_pos= new PVector(0,0);
  size(600,800);
  stroke(0,0,255);
}

int[] arr={30,30, 550,30, 450,30, 300,100, 
            75,200, 300,350, 450,175, 151,350, 
            15,330, 15,380, 450,350, 575,325,
            575,380, 300,500, 100,500, 550,500,
            100,700, 300,700, 550,700, 450,250,
            550,250, 15,275, 15,425, 575,420,
            575,275, 175,425, 220,300, 450,450};
int []edges = {0,4, 0,3, 4,3, 3,2, 3,6, 2,1,
                2,6, 6,19, 6,20, 19,10, 19,20, 5,7,
                5,10, 5,13, 10,11, 10,12, 11,12, 13,14,
                13,15, 14,16, 16,17, 17,18, 15,18, 7,8,
                7,9, 8,9, 19,5, 4,21, 14,22, 15,23, 20,24,
                14,25, 4,26, 5,26, 5,27, 5,25, 7,26, 27,15,
                23,27, 10,27};
float [][]adj_mat=new float[arr.length][arr.length];
PVector[] nodes=new PVector[arr.length/2];
int path_counter=1;
PVector target_pos;
int[] path_final={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
PVector mouse=new PVector();
PVector node = new PVector();
SteerShape shape=new SteerShape(0,0); 
void draw()
{ 
   int i,flag=-1;
   stroke(0,0,0);
   fill(0);
   background(255);
   //bathroom 1
   rect(0,300,150,10);
   rect(0,400,150,10);
   rect(150,300,5,30);
   rect(150,380,5,30);
   
   //staircase
   rect(500,50,100,125);
   
   //storeroom
   rect(500,300,100,10);
   rect(500,400,100,10);
   
   //kitchen table
   rect(150,550,350,100);
   
   //drawing-room table
   rect(250,150,100,100);
   for (i=0;i<arr.length;i=i+2)
   {
       ellipse(arr[i],arr[i+1],10,10);
   }
   int index = 0;
   for (i=0;i<arr.length;i=i+2)
   {
     nodes[index]=new PVector(arr[i],arr[i+1]);
     index++;
   }    
   for (i=0;i<arr.length;i++)
   {
       for (int j=0;j<arr.length;j++)
        {
            if (i==j)
              adj_mat[i][j]=0;
            else
              adj_mat[i][j]=Float.MAX_VALUE;
        }
   }
   for(i=0;i<edges.length;i+=2)
   {
      PVector n1 =nodes[edges[i]];
      PVector n2 =nodes[edges[i+1]];
      line(n1.x,n1.y,n2.x,n2.y);
      adj_mat[edges[i]][edges[i+1]] = PVector.dist(n1,n2);
      adj_mat[edges[i+1]][edges[i]] = PVector.dist(n1,n2);
   }
  
   if (mousePressed==true)
   {
     flag=-1;
     int closest;
     float least=Float.MAX_VALUE;
     mouse = new PVector(mouseX,mouseY);
     for(i=0;i<nodes.length;i++)
     {
       float distance = PVector.dist(mouse,nodes[i]);
       if (distance < least)
       {
         least = distance;
         node = nodes[i];
       }
     }
     fill(0,0,255);
     //path_counter=0;
     for(i=0;i<nodes.length;i++)
       if(nodes[i].x == node.x && nodes[i].y==node.y)
         index = i;
     path_counter=0;
     PVector char_pos = shape.char_pos;
     PVector node_cur=new PVector();
     least = Float.MAX_VALUE;
     for(i=0;i<nodes.length;i++)
     {
       float distance = PVector.dist(char_pos,nodes[i]);
       if (distance < least)
       {
         least = distance;
         node_cur = nodes[i];
       }
     }
     int index2=0;
     for(i=0;i<nodes.length;i++)
       if(nodes[i].x == node_cur.x && nodes[i].y==node_cur.y)
         index2 = i;
     path_final=astar(index2,index,arr.length/2);
   }
     PVector seek_temp;
     if(path_counter < path_final.length && path_final[path_counter]!=-1)
     {
       seek_temp = new PVector(nodes[path_final[path_counter]].x,nodes[path_final[path_counter]].y);
     }
     else
     {
       seek_temp = mouse;
       flag=1;
     }
     shape.steer(seek_temp);
     shape.display();
       int j;
     for (i=0;i<path_final.length;i++)
     {
       if(path_final[i] !=-1)// && path_final[i+1]!=-1)
        { 
          fill(0,0,255);
          ellipse(nodes[path_final[i]].x,nodes[path_final[i]].y,10,10);
          j=i-1;
          if (j>=0)
          {
            stroke(0,0,255);
            line(nodes[path_final[j]].x,nodes[path_final[j]].y,nodes[path_final[i]].x,nodes[path_final[i]].y);
          }
       println();  
      }
  
     }
      fill(255,0,0);
      println();
}
int[] astar(int source, int dest, int length)
{
  path_counter=0;
  float []shortest =new float[length];
  float []estimated=new float[length];
  int[] openlist =new int[length];
  int[] closedlist =new int[length];
  int [][]path=new int[length][length];

  for(int i=0;i<length;i++)
  {
      shortest[i]=Integer.MAX_VALUE;
      estimated[i]=Integer.MAX_VALUE;
      openlist[i]=0;
      closedlist[i]=0;
      for (int j=0;j<length;j++)
        path[i][j]=-1;
  }
  
  int current=source,no_expanded;
  shortest[source]=0;
  estimated[source]=PVector.dist(nodes[source],nodes[dest]);
  no_expanded=0;
  openlist[source]=1;
  path[source][0]=source;
  while(current!=dest)
  {
          no_expanded++;
          for(int i=0;i<length;i++)
          {
            if((adj_mat[current][i]!=Integer.MAX_VALUE)&&(adj_mat[current][i]>0)&&(closedlist[i]!=1))//edge exists
            {
              float heuristics = PVector.dist(nodes[i],nodes[dest]);
              float sum = shortest[current]+adj_mat[current][i] + heuristics;
              if(sum<estimated[i])
              {
                int j;
                estimated[i]=sum;  
                shortest[i]=sum-heuristics;
                for (j=0;path[current][j]!=-1;j++)
                  path[i][j] = path[current][j];
                 path[i][j]=i;
              }
                openlist[i]=1;
            }
          }
          closedlist[current]=1;
          openlist[current]=0;
          float least =Float.MAX_VALUE;
          for(int r=0;r<length;r++)
          {
            if((openlist[r]==1)&&(estimated[r]<least))
            {
                least=estimated[r];
                current =r;
            }
          }
    }
    int count=0,k=0;
    for (int i=0;i<length;i++)
      if(path[dest][i]!=-1)
        count++;
    int[] path_final=new int[count];
    for (int i=0;i<length;i++)
      if(path[dest][i]!=-1)
      {
        path_final[k]=path[dest][i];
        k++;
      }
     return path_final;    
}