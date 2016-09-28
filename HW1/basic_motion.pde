void setup()
{
  size(400, 400);
  background(255);
  stroke(0,0,255);
}
int x = 50;
int y = 350;
void draw()
{
  background(255);
  int i;
  if (y == 350 && x<350){
      ellipse(x, y, 50, 50);
      triangle(x, y-25, x, y + 25, x + 50, y);
      fill(0,0,255);
      x = x + 5;
      
      for (i=75;i<=x;i=i+10)
      {
        ellipse(i-31,y,10,10);
      }
      
  }
  if (x == 350 && y <= 350){
      ellipse(x, y, 50, 50);
      triangle(x-25,y, x+25,y, x, y-50);
      y= y - 5;
      for (i=375;i>y;i=i-10){
        ellipse(x,i-40,10,10);
      }
  }
  if (x <=350 && y == 50){
      ellipse(x, y, 50, 50);
      triangle(x,y-25,x,y+25,x-50,y);
      x = x-5;
      for (i=375;i>x;i=i-10){
          ellipse(i-40,y,10,10);
      }
  }
  if (x==50 && y>=50){
      ellipse(x, y, 50, 50);
      triangle(x-25,y, x+25, y, x, y+50);
      y = y+5;
      for (i=75;i<=y;i=i+10){
        ellipse(x,i-31,10,10);
      }
  }
}