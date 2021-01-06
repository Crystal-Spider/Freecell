class Deck
{
  String[] seeds = {"HEART", "DIAMOND", "CLUB", "SPADE"};
  String[] values = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"};
  ArrayList<ArrayList<Slot>> slotsList = new ArrayList<ArrayList<Slot>>();
  int prevCardIndex = -1;
  int prevSlotIndex = -1;
  int prevSlotlistIndex = -1;
  int prevSelSlotlistIndex = -1;
  int prevSelSlotIndex = -1;
  int prevSelCardIndex = -1;
  
  Deck(ArrayList<ArrayList<Slot>> list)
  {
    slotsList.clear();
    slotsList.addAll(list);
  }
  
  Deck()
  {
    ArrayList<Slot> cells = new ArrayList<Slot>();
    ArrayList<Slot> flushes = new ArrayList<Slot>();
    ArrayList<Slot> cardsets = new ArrayList<Slot>();
    
    int w = cardWidth + edge;
    int h = cardHeight + edge;
    
    for(int c = 0; c < 8; c++)
    {
      int x = c*w + edge/2;
      x += c > 3 ? width-(w*8+edge) : 0;
      int y = textSize*2 + edge/2;
      if(c <= 3)
      {
        cells.add(new Cell(x, y, w, h));
      }
      else
      {
        flushes.add(new Flush(x, y, w, h));
      }
      
      x = cardsetSpace + (cardWidth+cardsetSpace)*c;
      y = textSize*2 + cardsetSpace + h;
      cardsets.add(new Cardset(x, y, cardWidth, cardHeight));
    }  
    
    slotsList.add(flushes);  //0
    slotsList.add(cells);    //1
    slotsList.add(cardsets); //2
    
    ArrayList<Card> cards = new ArrayList<Card>();
    
    //Create the cards and store them into the ArrayList.
    for(int seed = 0; seed < seeds.length; seed++)
    {
      for(int value = 0; value < values.length; value++)
      {
        String cardName = seeds[seed] + "-" + values[value] + ".svg";
        cards.add(new Card(cardName, seeds[seed], value));
      }
    }
    
    //Shuffle the deck.
    this.shuffle(cards);
    
    //Give the cards x and y coordinates and move them inside the correct cardset.
    for(int c = 0; c < cards.size(); c++)
    {
      int x = cardsetSpace + (cardWidth+cardsetSpace)*(c%8);
      int y = textSize*2 + cardHeight + edge*2 + cardsetSpace + cardSpace*(c/8);
      cards.get(c).setxy(x, y);
      cardsets.get(c%8).addCard(cards.get(c));
    }
  }
  
  void shuffle(ArrayList<Card> cards)
  {
    for(int c = cards.size()-1; c > 0; c--)
    {
      int k = (int)Math.floor(Math.random() * (c + 1));
      Card card = cards.get(c);
      cards.set(c, cards.get(k));
      cards.set(k, card);
    }
  }
  
  ArrayList<ArrayList<Slot>> copyCards()
  {
    ArrayList<ArrayList<Slot>> copy = new ArrayList<ArrayList<Slot>>();
        
    ArrayList<Slot> cells = new ArrayList<Slot>();
    ArrayList<Slot> flushes = new ArrayList<Slot>();
    ArrayList<Slot> cardsets = new ArrayList<Slot>();
    
    int w = cardWidth + edge;
    int h = cardHeight + edge;
    
    for(int c = 0; c < 8; c++)
    {
      int x = c*w + edge/2;
      x += c > 3 ? width-(w*8+3) : 0;
      int y = textSize*2 + edge/2;
      if(c <= 3)
      {
        cells.add(new Cell(x, y, w, h));
      }
      else
      {
        flushes.add(new Flush(x, y, w, h));
      }
      
      x = cardsetSpace + (cardWidth+cardsetSpace)*c;
      y = textSize*2 + cardsetSpace + h;
      cardsets.add(new Cardset(x, y, cardWidth, cardHeight));
    }  
    
    copy.add(flushes);  //0
    copy.add(cells);    //1
    copy.add(cardsets); //2
    
    for(int slotsIndex = 0; slotsIndex < slotsList.size(); slotsIndex++)
    {
      ArrayList<Slot> slots = slotsList.get(slotsIndex);
      for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
      {
        Slot slot = slots.get(slotIndex);
        for(int cardIndex = 0; cardIndex < slot.size(); cardIndex++)
        {
          Card card = slot.cards.get(cardIndex);
          copy.get(slotsIndex).get(slotIndex).addCard(new Card(card));
        }
      }
    }
    return copy;
  }
  
  void selectCard()
  {
    int newCardIndex = -1;
    int newSlotIndex = -1;
    int newSlotlistIndex = -1;
    
    for(int slotlistIndex = 0; slotlistIndex < slotsList.size(); slotlistIndex++)
    {
      ArrayList<Slot> slots = slotsList.get(slotlistIndex);
      for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
      {
        Slot slot = slots.get(slotIndex);
        for(int cardIndex = 0; cardIndex < slot.size(); cardIndex++)
        {
          Card card = slot.cards.get(cardIndex);
          if(card.isMouseOver() && card.isSelectable())
          {
            card.setSelected(true);
            newCardIndex = slot.indexOf(card);
            newSlotIndex = slots.indexOf(slot);
            newSlotlistIndex = slotsList.indexOf(slots);
            if(!card.isLast())
            {
              for(int nextCardIndex = cardIndex+1; nextCardIndex < slot.size(); nextCardIndex++)
              {
                slot.get(nextCardIndex).setSelected(true);
              }
              break;
            }
          }
          else
          {
            card.setSelected(false);
          }
        }
      }
    }

    if(newCardIndex < 0)
    {
      for(int slotlistIndex = 0; slotlistIndex < slotsList.size(); slotlistIndex++)
      {
        ArrayList<Slot> slots = slotsList.get(slotlistIndex);
        for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
        {
          Slot slot = slots.get(slotIndex);
          if(slot.isSelectable())
          {
            Slot prevSlot = slotsList.get(prevSlotlistIndex).get(prevSlotIndex);
            Card prevCard = prevSlot.cards.get(prevCardIndex);
            
            Deck copy = new Deck(deck.copyCards());
            
            if((prevSlot.size()-prevSlot.indexOf(prevCard)) <= this.freecells(1))
            {
              if(slot.addCard(prevCard, prevSlot))
              {
                undos.add(new Deck(copy.copyCards()));
                prevSlot.removeCards(prevCard);
              }
            }
          }
        }
      }
    }
    else if(prevCardIndex >= 0)
    {
      Slot currentSlot = slotsList.get(newSlotlistIndex).get(newSlotIndex);
      Card currentCard = currentSlot.cards.get(newCardIndex);
      
      Slot prevSlot = slotsList.get(prevSlotlistIndex).get(prevSlotIndex);
      Card prevCard = prevSlot.cards.get(prevCardIndex);
      
      if(slotsList.get(1).indexOf(currentSlot) == -1)
      {
        Card newCard = slotsList.get(newSlotlistIndex).get(newSlotIndex).get(newCardIndex);
        if(prevCard.canMoveOnto(newCard) && newCard.isLast())
        {
          Deck copy = new Deck(deck.copyCards());
          
          if(currentSlot.addCard(prevCard, prevSlot))
          {
            undos.add(new Deck(copy.copyCards()));
          }
          currentCard.setSelected(false);
        }
      }
    }
    
    this.checkSelected();
  }
  
  boolean isCardSelected()
  {
    return prevCardIndex > -1;
  }
  
  void checkSelected()
  {
    prevCardIndex = -1;
    prevSlotIndex = -1;
    prevSlotlistIndex = -1;
    
    for(ArrayList<Slot> slots : slotsList)
    {
      for(Slot slot : slots)
      {
        for(Card card : slot.cards)
        {
          if(card.isSelected())
          {
            prevCardIndex = slot.indexOf(card);
            prevSlotIndex = slots.indexOf(slot);
            prevSlotlistIndex = slotsList.indexOf(slots);
            break;
          }
        }
        if(prevCardIndex > -1)
        {
          break;
        }
      }
      if(prevCardIndex > -1)
      {
        break;
      }
    }
  }
  
  int freecells(int sub)
  {
    int freeCells = 0;
    int freeCardsets = 0;
    for(Slot slot : slotsList.get(1))
    {
      if(slot.isEmpty())
      {
        freeCells++;
      }
    }
    for(Slot slot : slotsList.get(2))
    {
      if(slot.isEmpty())
      {
        freeCardsets++;
      }
    }
    
    freeCardsets -= freeCardsets > 0 ? sub : 0;
    return (freeCardsets)*(freeCells+1) + (freeCells+1);
  }
  
  void automaticPut()
  {
    int autoCardIndex = -1;
    int autoSlotIndex = -1;
    int autoSlotlistIndex = -1;
    
    for(int slotlistIndex = 0; slotlistIndex < slotsList.size(); slotlistIndex++)
    {
      ArrayList<Slot> slots = slotsList.get(slotlistIndex);
      for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
      {
        Slot slot = slots.get(slotIndex);
        for(int cardIndex = 0; cardIndex < slot.size(); cardIndex++)
        {
          Card card = slot.cards.get(cardIndex);
          if(card.isMouseOver() && card.isSelectable())
          {
            autoCardIndex = cardIndex;
            autoSlotIndex = slotIndex;
            autoSlotlistIndex = slotlistIndex;
          }
          card.setSelected(false);
        }
      }
    }
    
    if(autoCardIndex >= 0)
    {
      boolean freeSlotFound = false;
      
      Slot autoSlot = slotsList.get(autoSlotlistIndex).get(autoSlotIndex);
      Card autoCard = autoSlot.cards.get(autoCardIndex);
      
      ArrayList<Slot> slots = slotsList.get(0);  //Loop first though flushes.
      for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
      {
        Slot freeSlot = slots.get(slotIndex);
        Deck copy = new Deck(deck.copyCards());
        
        if(freeSlot.addCard(autoCard, autoSlot))
        {
          undos.add(new Deck(copy.copyCards()));
          
          autoSlot.removeCards(autoCard);
          freeSlotFound = true;
          break;
        }
      }
      
      if(!freeSlotFound)
      {
        slots = slotsList.get(1);  //Loop after though cells.
        for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
        {        
          Slot freeSlot = slots.get(slotIndex);
          Deck copy = new Deck(deck.copyCards());
          
          if(freeSlot.addCard(autoCard, autoSlot))
          {
            undos.add(new Deck(copy.copyCards()));
            
            autoSlot.removeCards(autoCard);
            freeSlotFound = true;
            break;
          }
        }
      }
      
      if(freeSlotFound)
      {
        prevCardIndex = -1;
        prevSlotIndex = -1;
        prevSlotlistIndex = -1;
      }
    }
  }
  
  JSONObject saveJson()
  {
    JSONObject savedGame = new JSONObject();
    
    JSONArray flushes = new JSONArray();
    JSONArray cells = new JSONArray();
    JSONArray cardsets = new JSONArray();
    
    int w = cardWidth + edge;
    int h = cardHeight + edge;
    
    for(int c = 0; c < 8; c++)
    {
      int x = c*w + edge/2;
      x += c > 3 ? width-(w*8+3) : 0;
      int y = textSize*2 + edge/2;
      if(c <= 3)
      {
        JSONObject cell = new JSONObject();
        cell.setInt("x", x);
        cell.setInt("y", y);
        cell.setInt("w", w);
        cell.setInt("h", h);
        cell.setJSONArray("cards", new JSONArray());
        
        cells.setJSONObject(c, cell);
      }
      else
      {
        JSONObject flush = new JSONObject();
        flush.setInt("x", x);
        flush.setInt("y", y);
        flush.setInt("w", w);
        flush.setInt("h", h);
        flush.setJSONArray("cards", new JSONArray());
        
        flushes.setJSONObject(c-4, flush);
      }
      
      x = cardsetSpace + (cardWidth+cardsetSpace)*c;
      y = textSize*2 + cardsetSpace + h;
      
      JSONObject cardset = new JSONObject();
      cardset.setInt("x", x);
      cardset.setInt("y", y);
      cardset.setInt("w", cardWidth);
      cardset.setInt("h", cardHeight);
      cardset.setJSONArray("cards", new JSONArray());
      
      cardsets.setJSONObject(c, cardset);
    }
    
    ArrayList<Slot> slots = slotsList.get(0);  //Flushes
    for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
    {
      Slot slot = slots.get(slotIndex);
      for(int cardIndex = 0; cardIndex < slot.size(); cardIndex++)
      {
        Card card = slot.get(cardIndex);
        JSONObject jsonCard = new JSONObject();
        jsonCard.setString("svgName", card.svgName);
        jsonCard.setString("seed", card.seed);
        jsonCard.setInt("value", card.value);
        jsonCard.setInt("x", card.x);
        jsonCard.setInt("y", card.y);
        
        flushes.getJSONObject(slotIndex).getJSONArray("cards").setJSONObject(cardIndex, jsonCard);
      }
    }
    
    slots = slotsList.get(1);  //Cells
    for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
    {
      Slot slot = slots.get(slotIndex);
      for(int cardIndex = 0; cardIndex < slot.size(); cardIndex++)
      {
        Card card = slot.get(cardIndex);
        JSONObject jsonCard = new JSONObject();
        jsonCard.setString("svgName", card.svgName);
        jsonCard.setString("seed", card.seed);
        jsonCard.setInt("value", card.value);
        jsonCard.setInt("x", card.x);
        jsonCard.setInt("y", card.y);
        
        cells.getJSONObject(slotIndex).getJSONArray("cards").setJSONObject(cardIndex, jsonCard);
      }
    }
    
    slots = slotsList.get(2);  //Cardsets
    for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
    {
      Slot slot = slots.get(slotIndex);
      for(int cardIndex = 0; cardIndex < slot.size(); cardIndex++)
      {
        Card card = slot.get(cardIndex);
        JSONObject jsonCard = new JSONObject();
        jsonCard.setString("svgName", card.svgName);
        jsonCard.setString("seed", card.seed);
        jsonCard.setInt("value", card.value);
        jsonCard.setInt("x", card.x);
        jsonCard.setInt("y", card.y);
        
        cardsets.getJSONObject(slotIndex).getJSONArray("cards").setJSONObject(cardIndex, jsonCard);
      }
    }
    
    savedGame.setJSONArray("cells", cells);
    savedGame.setJSONArray("flushes", flushes);
    savedGame.setJSONArray("cardsets", cardsets);
    return savedGame;
  }
  
  void loadJson(JSONObject savedGame)
  {
    ArrayList<Slot> slots = slotsList.get(0);  //Flushes
    for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
    {
      Slot slot = slots.get(slotIndex);
      int cardsSize = savedGame.getJSONArray("flushes").getJSONObject(slotIndex).getJSONArray("cards").size();
      if(cardsSize > 0)
      {
        JSONObject jsonCard = savedGame.getJSONArray("flushes").getJSONObject(slotIndex).getJSONArray("cards").getJSONObject(0);
        Card card = new Card(jsonCard.getString("svgName"), jsonCard.getString("seed"), jsonCard.getInt("value"));
        slot.addCard(card);
      }
    }
    
    slots = slotsList.get(1);  //Cells
    for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
    {
      Slot slot = slots.get(slotIndex);
      int cardsSize = savedGame.getJSONArray("cells").getJSONObject(slotIndex).getJSONArray("cards").size();
      if(cardsSize > 0)
      {
        JSONObject jsonCard = savedGame.getJSONArray("cells").getJSONObject(slotIndex).getJSONArray("cards").getJSONObject(0);
        Card card = new Card(jsonCard.getString("svgName"), jsonCard.getString("seed"), jsonCard.getInt("value"));
        slot.addCard(card);
      }
    }
    
    slots = slotsList.get(2);  //Cardsets
    for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
    {
      Slot slot = slots.get(slotIndex);
      int cardsSize = savedGame.getJSONArray("cardsets").getJSONObject(slotIndex).getJSONArray("cards").size();
      if(cardsSize > 0)
      {
        slot.cards.clear();
        for(int cardIndex = 0; cardIndex < cardsSize; cardIndex++)
        {
          JSONObject jsonCard = savedGame.getJSONArray("cardsets").getJSONObject(slotIndex).getJSONArray("cards").getJSONObject(cardIndex);
          Card card = new Card(jsonCard.getString("svgName"), jsonCard.getString("seed"), jsonCard.getInt("value"));
          slot.addCard(card);
        }
      }
      else
      {
        slot.cards.clear();
      }
    }
  }
  
  void renderOptimized()
  {
    boolean isSelectable = false;
    for(int slotlistIndex = 0; slotlistIndex < slotsList.size(); slotlistIndex++)
    {
      if(isSelectable){break;}
      
      ArrayList<Slot> slots = slotsList.get(slotlistIndex);
      for(int slotIndex = 0; slotIndex < slots.size(); slotIndex++)
      {
        Slot slot = slots.get(slotIndex);
        if(slot.isSelectable() && slot.isEmpty())
        {
          isSelectable = true;
          if(slotlistIndex != prevSelSlotlistIndex)
          {
            this.drawAndSet(slotlistIndex, slotIndex, -1);
          }
          else if(slotIndex != prevSelSlotIndex)
          {
            this.drawAndSet(slotlistIndex, slotIndex, -1);
          }
          break;
        }
        else
        {
          int cardIndex = slot.hasMouseOverSelectableCard();
          if(cardIndex > -1)
          {
            isSelectable = true;
            if(slotlistIndex != prevSelSlotlistIndex)
            {
              this.drawAndSet(slotlistIndex, slotIndex, cardIndex);
            }
            else if(slotIndex != prevSelSlotIndex)
            {
              this.drawAndSet(slotlistIndex, slotIndex, cardIndex);
            }
            else if(cardIndex != prevSelCardIndex)
            {
              this.drawAndSet(slotlistIndex, slotIndex, cardIndex);
            }
            break;
          }
        }
      }
    }

    if((prevSelSlotIndex > -1 || prevSelCardIndex > -1) && !isSelectable)
    {
      drawObjs();
      prevSelSlotlistIndex = -1;
      prevSelSlotIndex = -1;
      prevSelCardIndex = -1;
    }
  }
  
  void drawAndSet(int prevSelSlotlistIndex, int prevSelSlotIndex, int prevSelCardIndex)
  {
    this.prevSelSlotlistIndex = prevSelSlotlistIndex;
    this.prevSelSlotIndex = prevSelSlotIndex;
    this.prevSelCardIndex = prevSelCardIndex;
    drawObjs();
  }
  
  void render()
  {
    for(ArrayList<Slot> slots : slotsList)
    {
      for(Slot slot : slots)
      {
        slot.render();
      }
    }
  }
}
