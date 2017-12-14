//Nathan Grimberg
//Project2
//212208922
//03.29.2016

//Setup background image.
PImage backgroundImage;
PImage title;

//Array of colors for each airline
color airlines[] = {color(151,220,255),color(172,232,137),color(255,97,54),color(255,255,255),color(255,226,105)}; 

//Array of objects (Star) called stars
ArrayList <Star> stars = new ArrayList <Star> ();

// Declares a table
Table table;

int marginBottom = 50;
int marginTop = 10;
int marginLeft = 10;
int marginRight = 10;
int sampleSize = 3;

void setup()
{
  table = loadTable("data.csv", "header");
  smooth();
  size(800,1000);
  backgroundImage = loadImage("BG2.png");
  title = loadImage("Title.png");
  background(255);
  
  for (TableRow row : table.rows())
  {
    color airLineColor;
    int dateYears = row.getInt("year");
    int dateDays = row.getInt("days");
    int casualties = row.getInt("fatalities");
    String model = row.getString("model");
    String ae = row.getString("airline");
    
     if (ae.equals("AF"))
       airLineColor = airlines[3];
     else if (ae.equals("EA"))
       airLineColor = airlines[1];
     else if (ae.equals("IA"))
       airLineColor = airlines[4];
     else if (ae.equals("SA"))
       airLineColor = airlines[2];
     else
       airLineColor = airlines[0];
       
    stars.add(new Star(dateYears,dateDays,airLineColor,casualties,model));
  }
  
}

void draw()
{ 
  //Draw background, sorry Borzu, no gradients!
  image(backgroundImage,0,0);
  image(title,-5,height-50);
  drawScale();
  
  //Within stars list call drawStar() method
  for (Star ic : stars)
  {
    ic.drawLines();
    ic.drawStar();
  }
}

// Class Star, stores information regarding stars including, size, color, airplane model, year and day
class Star  
{
  int x,y,size;
  color starColor;
  String model;
  
  //Star Constructor
  Star(int tempY, int tempX, color country, int ammt, String modelTemp)
  {
    x = tempX;
    y = tempY;
    starColor = country;
    size = ammt;
    model = modelTemp;
    //println(model);
  }
  
  //Draws stars based on a case of "size" method 
  void drawStar()
  {
    float floatX = mapPosX(x);
    float floatY = mapPosY(y); //+ random(-10,10); // reverse these numbers for the opposite direction... 
    
    fill(starColor);
    
    noStroke();     
    if (size > 50) // draw largest star
    { 
      pushMatrix();
      //twinkle(10,3);
      translate(floatX,floatY);
      rotate(PI/4.0);
      quad(0 - 6,0,0,0 - 1,0 + 6,0,0,0 + 1);
      quad(0,0 - 6,0 - 1,0,0,0 + 6,0 + 1,0);    
      popMatrix();
      quad(floatX - 8,floatY,floatX,floatY - 2,floatX + 8,floatY,floatX,floatY + 2);
      quad(floatX,floatY - 8,floatX - 2,floatY,floatX,floatY + 8,floatX + 2,floatY);
    }
    else if(size > 10) // draw medium star
    {
      //twinkle(200,70);
      quad(floatX-7,floatY,floatX,floatY-2,floatX+7,floatY,floatX,floatY+2);
      quad(floatX,floatY-7,floatX-2,floatY,floatX,floatY+7,floatX+2,floatY);
    }
    else if(size > 0) // draw small star
    {
      //twinkle(100,90);
      ellipse(floatX,floatY,4,4);
    }
    else // draw tiniest star
    {
      //twinkle(5,3);
      ellipse(floatX,floatY,2,2);
    }
  } 
  void drawLines()
  {
    float floatX = mapPosX(x);
    float floatY = mapPosY(y);
    
    if (((mouseX > (floatX - sampleSize)) && (mouseX < (floatX + sampleSize)))&&((mouseY > (floatY - sampleSize)) && (mouseY < (floatY + sampleSize))))
    {
      String modelTemp;
      int dateYears,dateDays;
      for (TableRow row : table.rows())
      {
        modelTemp = row.getString("model");
        dateYears = row.getInt("year");
        dateDays = row.getInt("days");
        if (modelTemp.equals(model))
        {
          float lineX = mapPosX(dateDays);
          float lineY = mapPosY(dateYears);
          stroke(255,50);
          line(floatX,floatY,lineX,lineY);
          
          text(str(dateYears) + " - " + model , floatX + 5, floatY - 4);
        }
      }
    }
  }
  
  void twinkle(int sample, int seed) 
  {
   if (int(random(1,sample)) > seed)
   {
     fill(red(starColor),green(starColor),blue(starColor),100);
   }
  }
} //End Star Class

float mapPosY(int n)
{
  return map(n,2011,1944,marginTop,height - marginBottom);
}

float mapPosX(int n)
{
  return map(n,0,365,0 + marginLeft,width - marginRight);
}

void drawScale()
{
  stroke(255,100);
  fill(255,100);
  textSize(10);
  for (int i = 1945; i < 2012; i ++)
  {
    if ((i % 5)==0)
    {
      line(0,mapPosY(i),width,mapPosY(i));
      text(str(i),5,mapPosY(i)-5);
    }
  }
}