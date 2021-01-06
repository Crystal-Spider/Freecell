class Bar
{
  float newGameSize = textWidth("Nuova partita")+border*2;
  float restartGameSize = textWidth("Ricomincia partita")+border*2;
  float saveGameSize = textWidth("Salva partita")+border*2;
  float undoSize = textWidth("Torna indietro")+border*2;
  float barHeight = textSize*2;
  
  void render()
  {
    fill(195, 215, 222);
    strokeWeight(0);
    rect(0, 0, width, barHeight);
    
    strokeWeight(1);
    stroke(0);
    rect(0, 0, newGameSize, barHeight);
    fill(0);
    text("Nuova partita", border, yOffset);
    
    fill(195, 215, 222);
    rect(newGameSize, 0, restartGameSize, barHeight);
    fill(0);
    text("Ricomincia partita", newGameSize+border, yOffset);
    
    fill(195, 215, 222);
    rect(newGameSize+restartGameSize, 0, saveGameSize, barHeight);
    fill(0);
    text("Salva partita", newGameSize+restartGameSize+border, yOffset);
    
    fill(195, 215, 222);
    rect(width-undoSize, 0, undoSize, barHeight);
    fill(0);
    text("Torna indietro", width+border-undoSize, yOffset);
  }
  
  boolean isOverReset()
  {
    return mouseX > 0 && mouseX < newGameSize && isOverBar();
  }
  
  boolean isOverRestart()
  {
    return mouseX > newGameSize && mouseX < restartGameSize+newGameSize && isOverBar();
  }
  
  boolean isOverSave()
  {
    return mouseX > newGameSize+restartGameSize && mouseX < saveGameSize+restartGameSize+newGameSize && isOverBar();
  }
  
  boolean isOverUndo()
  {
    return mouseX > width-undoSize && mouseX < width && isOverBar();
  }
  
  boolean isOverBar()
  {
    return mouseY > 0 && mouseY < barHeight;
  }
}
