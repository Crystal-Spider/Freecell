class Cardset extends Slot
{
  Cardset(int x, int y, int w, int h)
  {
    super(x, y, w, h);
  }
  
  void render()
  {
    if(!this.isEmpty())
    {
      for(Card card : this.cards)
      {
        card.render();
      }
      noFill();
    }
    else if(this.isSelectable())
    {
      fill(overColor);
    }
    else
    {
      noFill();
    }
    noStroke();
    rect(x, y, w, h);
  }
}
