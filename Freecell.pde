//Global objects.
Bar bar;    //Game bar for options.
Deck deck;  //Object to store the cards.
Deck ini;   //Object to store initial state of deck.
ArrayList<Deck> undos = new ArrayList<Deck>(); //Object to store the moves.
//Global objects.

//Global variables.
int frameRate = 30;
int cardWidth;
int cardHeight;
int border;
int edge;
int cardsetSpace;
int cardSpace;
int textSize;
int yOffset;
float savedGameWritingDurationLeft = 0;
int loadingWritingDurationLeft = 0;
boolean isLoading = false;
final String loadingWriting = "CARICAMENTO...";
final String savedGameWriting = "PARTITA SALVATA";
//Global variables.

void settings()
{
  cardWidth = (int) (displayWidth / 15.36);
  cardHeight = (int) (displayHeight / 6.17);
  border = cardWidth / 10;
  edge = border / 3;
  cardsetSpace = border + edge * 2;
  cardSpace = (int) (cardHeight / 4.6);
  textSize = displayHeight / 54;
  yOffset = textSize + 8;
  size(cardWidth * 8 + cardsetSpace * 9, cardHeight * 5 + textSize * 2);
}

void setup()
{
  frameRate(frameRate);
  textSize(textSize);
  bar = new Bar();
  
  if(loadJSONObject("savedGame.json").getBoolean("isSaved"))
  {
    background(60, 145, 50);
    bar.render();
    fill(0);
    rect(width/2-textWidth(loadingWriting)/2-border, height-height/5-28, textWidth(loadingWriting)+border*2, textSize*2);
    fill(255);
    text(loadingWriting, width/2-textWidth(loadingWriting)/2, height-height/5);
    isLoading = true;
    loadingWritingDurationLeft = 1;
  }
  else
  {
    reset();
  }
}

void draw()
{
  if(loadingWritingDurationLeft > 0)
  {
    if(isLoading)
    {
      isLoading = false;
      load(loadJSONObject("savedGame.json"));
    }
    fill(0);
    rect(width/2-textWidth(loadingWriting)/2-border, height-height/5-28, textWidth(loadingWriting)+border*2, textSize*2);
    fill(255);
    text(loadingWriting, width/2-textWidth(loadingWriting)/2, height-height/5);
  }
  else
  {
    deck.renderOptimized();
    if(savedGameWritingDurationLeft > 0)
    {
      fill(0);
      rect(width/2-textWidth(savedGameWriting)/2-border, height-height/5-28, textWidth(savedGameWriting)+border*2, textSize*2);
      fill(255);
      text(savedGameWriting, width/2-textWidth(savedGameWriting)/2, height-height/5);
      savedGameWritingDurationLeft--;
    }
    else if(savedGameWritingDurationLeft == 0)
    {
      drawObjs();
      savedGameWritingDurationLeft = -1;
    }
  }
}

void mousePressed()
{
  if(loadingWritingDurationLeft == 0)
  {
    if(mouseButton == LEFT)
    {
      deck.selectCard();
    }
    else if(mouseButton == RIGHT)
    {
      deck.automaticPut();
      
      if(bar.isOverUndo() && undos.size()>0)
      {
        Deck undo = undos.get(undos.size()-1);
        deck = new Deck(undo.copyCards());
        undos.remove(undo);
      }
      else if(bar.isOverRestart())
      {
        restart();
      }
      else if(bar.isOverReset())
      {
        reset();
      }
      else if(bar.isOverSave())
      {
        save(true);
        savedGameWritingDurationLeft = frameRate;
      }
    }
    drawObjs();
  }
}

void reset()
{
  deck = new Deck();
  ini = new Deck(deck.copyCards());
  undos.clear();
  undos.add(new Deck(deck.copyCards()));
  save(false);
  drawObjs();
}

void restart()
{
  deck = new Deck(ini.copyCards());
  undos.clear();
  undos.add(new Deck(deck.copyCards()));
  save(false);
  drawObjs();
}

void load(JSONObject savedGame)
{ 
  JSONObject currentState = savedGame.getJSONObject("currentState");
  JSONObject initialState = savedGame.getJSONObject("initialState");
  JSONArray prevStates = savedGame.getJSONArray("prevStates");
  
  deck = new Deck();
  deck.loadJson(currentState);
  
  ini = new Deck();
  ini.loadJson(initialState);
  
  undos.clear();
  loadingWritingDurationLeft = prevStates.size();
  for(int c = 0; c < prevStates.size(); c++, loadingWritingDurationLeft--)
  {
    Deck undo = new Deck();
    undo.loadJson(prevStates.getJSONObject(c));
    undos.add(undo);
  }
  
  save(false);
}

void save(boolean isSaved)
{
  JSONObject savedGame = new JSONObject();
  
  savedGame.setBoolean("isSaved", isSaved);
  if(isSaved)
  {
    JSONObject currentState = deck.saveJson();
    JSONObject initialState = ini.saveJson();
    JSONArray prevStates = new JSONArray();
    for(int c = 0; c < undos.size(); c++)
    {
      prevStates.setJSONObject(c, undos.get(c).saveJson());
    }
    
    savedGame.setJSONObject("currentState", currentState);
    savedGame.setJSONObject("initialState", initialState);
    savedGame.setJSONArray("prevStates", prevStates);
  }
  saveJSONObject(savedGame, "data/savedGame.json");
}

void drawObjs()
{
  background(60, 145, 50);
  bar.render();
  deck.render();
}
