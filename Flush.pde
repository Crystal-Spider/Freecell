class Flush extends Slot
{
  Flush(int x, int y, int w, int h)
  {
    super(x, y, w, h);
  }
  
  boolean addCard(Card card, Slot slot)
  {
    boolean flag = false;
    
    if(slot.indexOf(card) == slot.size()-1)
    {
      if(cards.isEmpty())
      {
        flag = card.value == 0;
      }
      else
      {
        Card topCard = cards.get(cards.size()-1);
        flag = card.seed.equals(topCard.seed) && card.value == topCard.value+1;
      }
      if(flag)
      {
        card.setxy(this.x, this.y);
        card.setSelected(false);
        cards.clear();
        cards.add(card);
        this.setSelectableCards();
        this.setLastCard();
      }
    }
    
    return flag;
  }
  
  void removeCards(){}
  
  void setSelectableCards()
  {
    for(Card card : cards)
    {
      card.setSelectable(false);
    }
  }
  
  boolean isSelectable()
  {
    return this.isMouseOver() && deck.isCardSelected();
  }
}
