class Slot
{
  int x;
  int y;
  
  int w;  //Width
  int h;  //Height
  
  color overColor = color(0, 0, 255, 63);
  int strokeWeight = edge;
  color strokeColor = color(65, 179, 58);
  
  ArrayList<Card> cards = new ArrayList<Card>();
  
  Slot(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  int indexOf(Card card)
  {
    return cards.indexOf(card);
  }
  
  Card get(int index)
  {
    return cards.get(index);
  }
  
  int size()
  {
    return cards.size();
  }
  
  boolean isEmpty()
  {
    return this.cards.isEmpty();
  }
  
  boolean addCard(Card card)
  {
    int y = this.y + cardSpace*cards.size();
    card.setxy(this.x, y);
    card.setSelected(false);
    this.cards.add(card);
    this.setSelectableCards();
    this.setLastCard();
    return true;
  }
  
  boolean addCard(Card card, Slot slot)
  {
    ArrayList<Card> removedCards = slot.removeCards(card);
    
    for(Card removedCard : removedCards)
    {
      int y = this.y + cardSpace*cards.size();
      removedCard.setxy(this.x, y);
      removedCard.setSelected(false);
      this.cards.add(removedCard);
      this.setSelectableCards();
      this.setLastCard();
    }
    return removedCards.size() > 0 ? true : false;
  }
  
  ArrayList<Card> removeCards(Card card)
  {
    ArrayList<Card> removedCards = new ArrayList<Card>();
    int index = cards.indexOf(card);
    
    if(index > -1)
    {
      if(cards.size()-index <= deck.freecells(0))
      {
        for(int c = index; c < cards.size(); c++)
        {
          Card removedCard = cards.get(c--);
          cards.remove(removedCard);
          removedCards.add(removedCard);
        }
        this.setSelectableCards();
        this.setLastCard();
      }
    }
    
    return removedCards;
  }
  
  void setSelectableCards()
  {
    if(!this.isEmpty())
    {
      boolean lastSet = true;
      cards.get(cards.size()-1).setSelectable(true);
      
      for(int c = cards.size()-2; c >= 0; c--)
      {
        Card currentCard = cards.get(c);
        Card nextCard = cards.get(c+1);
        if(nextCard.canMoveOnto(currentCard) && lastSet)
        {
          cards.get(c).setSelectable(true);
        }
        else
        {
          lastSet = false;
          cards.get(c).setSelectable(false);
        }
      }
    }
  }
  
  void setLastCard()
  {
    if(!this.isEmpty())
    {
      cards.get(cards.size()-1).last = true;
      for(int c = cards.size()-2; c >= 0; c--)
      {
        cards.get(c).last = false;
      }
    }
  }
  
  boolean isSelectable()
  {
    return this.isMouseOver() && deck.isCardSelected() && this.isEmpty();
  }
  
  boolean isMouseOver()
  {
    return mouseX > x && mouseX < (x+cardWidth) && mouseY > y && mouseY < (y+cardHeight);
  }
  
  int hasMouseOverSelectableCard()
  {
    int index = -1;
    for(Card card : cards)
    {
      if(card.isSelectable() && card.isMouseOver() && !card.isSelected())
      {
        index = cards.indexOf(card);
        break;
      }
    }
    return index;
  }
  
  void render()
  {
    strokeWeight(this.strokeWeight);
    stroke(this.strokeColor);
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
    rect(x, y, w, h);
  }
}
