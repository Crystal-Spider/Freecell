//Global objects.
Bar bar;    //Game bar for options.
Deck deck;  //Object to store the cards.
Deck ini;   //Object to store initial state of deck.
ArrayList<Deck> undos = new ArrayList<Deck>(); //Object to store the moves.
//Global objects.

//Global variables.
int frameRate = 30;
int edge = 4;
int border = 12;
int cardWidth = 125;
int cardHeight = 175;
int cardsetSpace = 20;
int cardSpace = (int)(cardHeight/4.6);
int textSize = 20;
int yOffset = 28;  //To be set manually.
float savedGameWritingDurationLeft = 0;
int loadingWritingDurationLeft = 0;
boolean isLoading = false;
//Global variables.

void settings()
{
  int w = cardWidth*8 + cardsetSpace*9;
  int h = cardHeight*5 + textSize*2;
  size(w, h);
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
    rect(width/2-textWidth("CARICAMENTO...")/2-border, height-height/5-28, textWidth("CARICAMENTO...")+border*2, textSize*2);
    fill(255);
    text("CARICAMENTO...", width/2-textWidth("CARICAMENTO...")/2, height-height/5);
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
    rect(width/2-textWidth("CARICAMENTO...")/2-border, height-height/5-28, textWidth("CARICAMENTO...")+border*2, textSize*2);
    fill(255);
    text("CARICAMENTO...", width/2-textWidth("CARICAMENTO...")/2, height-height/5);
  }
  else
  {
    deck.renderOptimized();
    if(savedGameWritingDurationLeft > 0)
    {
      fill(0);
      rect(width/2-textWidth("PARTITA SALVATA")/2-border, height-height/5-28, textWidth("PARTITA SALVATA")+border*2, textSize*2);
      fill(255);
      text("PARTITA SALVATA", width/2-textWidth("PARTITA SALVATA")/2, height-height/5);
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
