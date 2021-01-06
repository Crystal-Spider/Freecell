class Cell extends Slot
{
  Cell(int x, int y, int w, int h)
  {
    super(x, y, w, h);
  }
  
  boolean addCard(Card card, Slot slot)
  {
    if(slot.indexOf(card) == slot.size()-1)
    {
      if(cards.isEmpty())
      {
        card.setxy(this.x, this.y);
        card.setSelected(false);
        this.cards.add(card);
        this.setSelectableCards();
        this.setLastCard();
        return true;
      }
      else
      {
        return false;
      }
    }
    else
    {
      return false;
    }
  }
}
