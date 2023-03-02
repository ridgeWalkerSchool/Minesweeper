import de.bezier.guido.*;
public final static int NUM_ROWS = 16;
public final static int NUM_COLS = 30;
public int NUM_MINES = (int)(.12*(NUM_ROWS*NUM_COLS));
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public boolean gameOver = false;

void setup () {
  size(600, 320);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];

  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }

  setMines();
}
public void setMines() {
  for (int i = 0; i < NUM_MINES; i++) {
    int nr = (int)(Math.random()*NUM_ROWS);
    int nc = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[nr][nc])) {
      mines.add(buttons[nr][nc]);
    } else {
      i--;
    }
  }
}

public void draw () {
  background( 0 );
  if (isWon() == true) {
    displayWinningMessage();
  }
}
public boolean isWon() {
  int countC = 0;
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (buttons[r][c].clicked == true) {
        countC++;
      }
    }
  }
  if (countC == (NUM_ROWS*NUM_COLS)-NUM_MINES) {
    for (int i = 0; i < mines.size(); i++) {
      mines.get(i).win(color(0, 0, 200));
    }
    return true;
  }
  return false;
}
public void displayLosingMessage() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (buttons[r][c].clicked == false) {
        buttons[r][c].mousePressed();
      }
    }
  }
}
public void displayWinningMessage() {
  for (int i = 0; i < mines.size(); i++) {
    mines.get(i).win(color(0, 0, 200));
  }
  for(int r = 0; r < buttons.length; r++){
    for(int c = 0; c < buttons[r].length; c++){
      buttons[r][c].setLabel("W");
    }
  }
}
public boolean isValid(int r, int c) {
  if (r>=0&&r<NUM_ROWS&&c>=0&&c<NUM_COLS) {
    return true;
  }
  return false;
}
public int countMines(int row, int col) {
  int numMines = 0;
  if (isValid(row-1, col-1)&&(mines.contains(buttons[row-1][col-1]))) {//11
    numMines++;
  }
  if (isValid(row-1, col)&&(mines.contains(buttons[row-1][col]))) {//12
    numMines++;
  }
  if (isValid(row-1, col+1)&&(mines.contains(buttons[row-1][col+1]))) {//13
    numMines++;
  }
  if (isValid(row, col-1)&&(mines.contains(buttons[row][col-1]))) {//21
    numMines++;
  }
  if (isValid(row, col+1)&&(mines.contains(buttons[row][col+1]))) {//23
    numMines++;
  }
  if (isValid(row+1, col-1)&&(mines.contains(buttons[row+1][col-1]))) {//31
    numMines++;
  }
  if (isValid(row+1, col)&&(mines.contains(buttons[row+1][col]))) {//32
    numMines++;
  }
  if (isValid(row+1, col+1)&&(mines.contains(buttons[row+1][col+1]))) {//33
    numMines++;
  }
  return numMines;
}
public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
  private color flaggedColor;

  public MSButton ( int row, int col ) {
    width = 600/NUM_COLS;
    height = 320/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this );
  }
  public void mousePressed () {
    if (mouseButton == LEFT) {
      clicked = true;
    }

    if (!isWon()&&!gameOver) {
      if (mouseButton == RIGHT && myLabel == "") {
        if (mines.contains(this)) {
          clicked = false;
          flagged = !flagged;
        } else if (clicked == false) {
          clicked = false;
          flagged = !flagged;
        }
      } else if (!flagged) {
        clicked = true;
        if (mines.contains(this)) {
          gameOver = true;
          displayLosingMessage();
        } else if (countMines(myRow, myCol) > 0) {
          setLabel("" + countMines(myRow, myCol));
        } else {
          for (int rr = -1; rr < 2; rr++) {
            for (int cc = -1; cc < 2; cc++) {
              if (isValid(myRow+rr, myCol+cc) && buttons[myRow+rr][myCol+cc].clicked == false) {
                buttons[myRow+rr][myCol+cc].mousePressed();
              }
            }
          }
        }
      }
    }
  }

  public void draw () {    
    if (flagged)
      flaggedColor = color(0);
    else if (mines.contains(this) && isWon()) {
      clicked = false;
      flaggedColor = color(100, 255, 100);
    } else if ( clicked && mines.contains(this) ) 
      flaggedColor = color(255, 0, 0);
    else if (clicked)
      flaggedColor = color(200);
    else 
    flaggedColor = color(100);

    fill(flaggedColor);

    rect(x, y, width, height);
    if (countMines(myRow, myCol)==1) {
      fill(0,0,255);
    } else if (countMines(myRow, myCol) == 2) {
      fill(0, 100, 0);
    } else if (countMines(myRow, myCol) == 3) {
      fill(255, 0, 0);
    } else if (countMines(myRow, myCol) == 4) {
      fill(0, 0, 100);
    } else if (countMines(myRow, myCol) == 5) {
      fill(100, 0, 0);
    }
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged() {
    return flagged;
  }
  public void win(color setColor) {
    flaggedColor = setColor;
  }
}
