class Card
{
  String svgName;
  PShape svg;
  int x;
  int y;
  String seed;
  int value;
  boolean selectable;
  boolean selected;
  boolean last;
  
  Card(){}
  
  Card(Card card)
  {
    this.svgName = card.svgName;
    this.svg = card.svg;
    this.x = card.x;
    this.y = card.y;
    this.seed = card.seed;
    this.value = card.value;
  }
  
  Card(String svgName, String seed, int value)
  {
    this.svgName = svgName;
    this.svg = loadShape(svgName);
    this.seed = seed;
    this.value = value;
  }
  
  boolean canMoveOnto(Card card)
  {
    return this.hasOppositeColor(card) && this.isNextLower(card);
  }
  
  boolean hasOppositeColor(Card card)
  {
    boolean result = true;
    switch(card.seed)
    {
      case "DIAMOND":
      case "HEART":
        if(this.seed.equals("HEART") || this.seed.equals("DIAMOND"))
        {
          result = false;
        }
        break;
      case "CLUB":
      case "SPADE":
        if(this.seed.equals("CLUB") || this.seed.equals("SPADE"))
        {
          result = false;
        }
        break;
    }
    return result;
  }
  
  boolean isNextLower(Card card)
  {
    return this.value == card.value-1;
  }
  
  boolean isLast()
  {
    return this.last;
  }
  
  void setxy(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  void setSelectable(boolean selectable)
  {
    this.selectable = selectable;
  }
  
  boolean isSelectable()
  {
    return this.selectable;
  }
  
  void setSelected(boolean selected)
  {
    this.selected = selected;
  }
  
  boolean isSelected()
  {
    return this.selected;
  }
  
  boolean isMouseOver()
  {
    return mouseX > x && mouseX < (x+cardWidth) && mouseY > y && mouseY < (this.isLast() ? y+cardHeight : y+cardSpace);
  }
  
  void render()
  {
    shape(svg, x, y, cardWidth, cardHeight);
    fill(0, 0);
    if(this.isMouseOver() && this.selectable && !this.selected)
    {
      strokeWeight(4);
      stroke(255, 0, 0);
    }
    else if(this.selected)
    {
      strokeWeight(4);
      stroke(0, 0, 255);
    }
    else
    {
      strokeWeight(2);
      stroke(0);
    }
    rect(x-1, y-1, cardWidth+1, cardHeight+1);
  }
}
