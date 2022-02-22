/*FOP END SEMESTER PROJECT : "FLAPPY BIRD"
BY UMER ABDULLAH KHAN
BEE-13-D*/
PImage bg, bird, tpipe, bpipe;
/* bg = background
   tpipe is the image of the pipe with top facing downwards
   bpipe is the image of the pipe with top facing upwards*/ 
float bgx, bgy, ux, uy, Vuy, Vux; 
/* bgx is the position of background on x-axis
   bgy is the position of background on y-axis
   ux is the position of bird on x-axis
   uy is the position of bird on y-axis
   Vux is the horizontal velocity
   Vuy is the vertical velocity*/
     
float gv;   //gv is the gravity in the vertical direction
float[] pipex, pipey;  
/* Two arrays are defined for pipes*/
float gameState, score, bestscore;
/* gameState checks the mode of the game
   score is for the current score
   best score is for the highest score*/
   
void setup()             
/*void indicates no return value
setup function runs once only at the start and initialises variables, load images etc.*/
{
  size(1200,1000);                  //first function after setup to define dimensions of the game in pixels  (width, height)
  bg = loadImage("bg.png");                         //loads or inserts background image
  bird = loadImage("bird.png");                     //loads image of the bird
  tpipe = loadImage("tpipe.png");                   //loads tpipe
  bpipe = loadImage("bpipe.png");                   //loads bpipe
  
  //initial position of bird and value of gravity set
  ux = 100;                                        
  uy = 150;                                       
  gv = 0.1; 
  
  //arrays are declared
  pipex = new float[1000];                 //size of array determined as 100 i.e 100 pipes created
  pipey = new float[pipex.length];        
  
  //for loop created
  for(int i = 0; i < pipex.length; i++)    
  {
    pipex[i] = 200*i;                        
    /*determines width between two pipes 
    if random function used, pipes will overlap*/
    pipey[i] = random(-350, 0); 
    /*random function generates random numbers
    returns values starting at -350 and up to (but not including) 0 
    determines random height difference between top and bottom pipes in the range*/
  } 
  
  gameState = -1;      //start screen slide mode
    
} 
void background()
{
  image(bg, bgx, bgy);    
  image(bg, bgx + bg.width, bgy);   
  /*moves the image by distance equalling the width of the image*/
  bgx = bgx - 4;    
  /*- means image moves to the left
  4 determines the speed of movement*/
  if(bgx < -bg.width)
  /*when image has moved the distance equalling its width, 
  it will reset and thus go on forever*/
  {
    bgx = 0;
  }
}
//control of the bird
void bird()
{
  image(bird, ux, uy);  
  ux = ux + Vux;           //horizontal velocity of bird
  uy = uy + Vuy;           //vertical velocity of bird           
  Vuy = Vuy + gv;          //vertical acceleration of bird
  
  if (ux > bg.width) 
  //if the bird goes out of screen from right or left end, bird emerges from the other end
  { 
    ux = 0;   
  }
  
  if (uy < 0 || uy > height) 
  //if the bird goes out of the screen from upper or lower end, game ends
  {
    gameState=1;
  }
}
void draw()
{ //start screen mode
  if(gameState==-1)
  {
    startscreen();
  }
  //game mode
  else if(gameState==0)
  {
  background();
  pipe();
  bird();    //bird printed after pipe so that bird layer on top of the pipe layer in the game
  score();
  }
  //end screen mode
  else
  {
    endScreen();
    restart();
  }
} 
void endScreen()
{
          //form a rectangle
          fill(10, 260, 450, 10);
          rect(450, 150, 500, 140, 5);   
          //write text
          fill(0);         
          textSize(40);    
          text("Oops :(", 570,200);
          text("Press SPACE key to play again" , 455, 270); 
          //text appears inside rectangle
}

void restart()
{
  if(keyCode==32 || mousePressed)  //32 is the keycode for spacebar
          {
              uy = height/2; 
              ux = width- 300;
              /*bird resumes its position on screen 
              when enter key or mouse pressed*/
              for(int i = 0; i < pipex.length; i++)
              {
                pipex[i] = width + 200*i;
                pipey[i] = (int)random(-350, 0);
              }      
              score = 0;   //score resets
              gameState = 0; //game mode 
           } 
}
void keyPressed()  
/* controlling the bird via keyboard usng inbuit keyPressed function
For non-ASCII keys, we use the keyCode variable*/
{
  if (key ==CODED) 
  {
    if (keyCode == UP) 
    {
    Vuy = -4;   //negative means movement in upward direction
    } 
    else if (keyCode == DOWN) 
    { 
    Vuy = 1.5;      //Vuy DOWN is less than Vuy UP as also there is the effect of acceleration due to gravity
    }
    else if (keyCode == RIGHT)
    { 
       Vux = 1.1;
    }
    else if (keyCode == LEFT)
    { 
       Vux = -1.1;
    }
  }
}
void pipe()
{
  for(int i = 0; i < pipex.length; i++)
  {
    image(tpipe, pipex[i], pipey[i]);
    image(bpipe, pipex[i], pipey[i] + 680);
    /*680 value decided by hit and trial method
    it provides enough gap between the two pipes verically*/
    pipex[i]-=1;
    /*pipe width 92 pixels
    pipe height 437 pixels 
    bird width 35 pixels
    bird height 45 pixels*/
   if(ux > (pipex[i]-35) && ux < (pipex[i] + 92))
   /*as soon as bird collides with pipe from the left side, game ends
   -35 written as 35 is the width of bird and images x,y co-ordinates are read from their top-left corner
   if -35 not written, then collison occurs between top-left corner not the right face of the bird*/
   {
     if(! (uy > pipey[i] + 437 && uy < pipey[i] + (437 + 243 -45)))  
     /*paremeters set are for the safe zone
     ! added so that if game ends when bird is not in the safe zone
     safe zone is the area between the two pipes' up and bottom face
     680 - 437 = 243
     -45 added to incorporate the fact that collision must occur with top face of bird and not the top-left corner
     */
     {
       gameState = 1; //game ends
     }
     else
     {
       score+=0.08;   //0.08 added to score for each millisecond it remains under the pipe
     }
  }
 
  } 
}

void score()
{
        if(score>bestscore)
        {
          bestscore = score;   //overwrites best score if score > previous best score
        }
        //form a rectangle
        fill(160,160,160, 200); 
        rect(840, 10, 240, 90, 5);
        //write text
        fill(255,255,0);
        textSize(40);
        text("Score: " + (int)score, 840, 42);  
        text("Highscore:  " + (int)bestscore, 840, 80); 
        //score and bestscore appear inside the rectangle
}
void startscreen()
{
  image(bg, 0, 0);    
  /*backround image and its perimeters defined
  0, 0 denote the x and y co-ordinate of the top-left point of the image*/
  
    /*fill(v1, v2, v3, alpha) for color
    v1  red value
    v2  green value
    v3  blue value 
    alpha   opacity
                              
    rect(a, b, c, d, r) draws a rectangle
    a x-coordinate 
    b y-coordinate
    c width of the rectangle
    d height
    r radii for all four corners
    
    text(c, x, y)
    c string
    x x-coordinate 
    y y-coordinate*/
    
  fill(10, 260, 450, 200);                         
  rect(450, 300, 600, 140, 5);  
                              
  fill(13, 15, 10, 140);
  rect(50, 100, 600, 140, 5); 
  
  fill(255, 200, 34);
  textSize(100);   //size of text set as 100
  text("FLAPPY BIRD", 75, 200);
  
  fill(10, 0, 0);
  textSize(42);
  text("WELCOME TO FLAPPY BIRD!!", 470, 340);
  text("Press ENTER key to start the game", 450, 410);
  
  if(keyCode==10 || mousePressed)    //keycode for enter key is 10
  {
    uy = height/2;   //initial position of bird in the middle of screen vertically
    gameState = 0;   //game mode on if enter key or mouse pressed
  }
}



      
      

      
