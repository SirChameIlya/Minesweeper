import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 10;
public final static int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  textSize(10);
  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setMines();
}
public void setMines()
{
  //your code
  for (int i = 0; i < 17; i++) {
    int randomRow = (int)(Math.random() * NUM_ROWS);
    int randomColumn = (int)(Math.random() * NUM_COLS);
    if ( ! mines.contains( buttons[randomRow][randomColumn] ) ) {
      mines.add(buttons[randomRow][randomColumn]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if ( buttons[r][c].clicked == false && mines.contains( buttons[r][c] ) == false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (mines.contains(buttons[r][c] ) ) {
        fill(255, 0, 0);
        buttons[r][c].setLabel("You lose!");
      }
      buttons[r][c].clicked = true;
      if ( countMines(buttons[r][c].myRow, buttons[r][c].myCol ) > 0 ) {
        buttons[r][c].  setLabel( countMines(buttons[r][c].myRow, buttons[r][c].myCol ) );
      }
    }
  }
  noLoop();
  //your code here
}
public void displayWinningMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].setLabel("You win!");
      buttons[r][c].clicked = true;
    }
  }
  noLoop();
  //your code here
}
public boolean isValid(int r, int c)
{
  if (r >=0 && r < NUM_ROWS && c >=0 && c < NUM_COLS) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r < row + 2; r++) {
    for (int c = col - 1; c < col + 2; c++) {
      if ( isValid(r, c) && mines.contains( buttons[r][c] ) ) {
        numMines++;
      }
      if ( isValid(row, col) && mines.contains( buttons[row][col] ) ) {
        numMines--;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      if (flagged == true) {
        flagged = false;
        clicked = false;
      }
      if (flagged == false) {
        flagged = true;
      }
    } else if ( mines.contains(this) ) {
      displayLosingMessage();
    } else if ( countMines(myRow, myCol ) > 0 ) {
      setLabel( countMines(myRow, myCol ) );
    } else {
      for (int r = myRow - 1; r < myRow + 2; r++) {
        for (int c = myCol - 1; c < myCol + 2; c++) {
          if ( isValid(r, c) &&  buttons[r][c] != buttons[myRow][myCol] && buttons[r][c].clicked == false) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
    //your code here
  }
  public void draw () 
  {    
    if (flagged) {
      fill(0); //black
    } else if ( clicked && mines.contains(this) ) {
      fill(255, 0, 0); //red
    } else if (clicked) {
      fill( 200 ); // light gray
    } else {
      fill( 100 ); //dark gray
    }
    rect(x, y, width, height);
    fill(0);

    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
