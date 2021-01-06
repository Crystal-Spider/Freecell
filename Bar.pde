class Bar
{
  final String newGame = "Nuova partita";
  final String restartGame = "Ricomincia partita";
  final String saveGame = "Salva partita";
  final String undoMove = "Torna indietro";
  
  float newGameSize = textWidth(newGame)+border*2;
  float restartGameSize = textWidth(restartGame)+border*2;
  float saveGameSize = textWidth(saveGame)+border*2;
  float undoSize = textWidth(undoMove)+border*2;
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
    text(newGame, border, yOffset);
    
    fill(195, 215, 222);
    rect(newGameSize, 0, restartGameSize, barHeight);
    fill(0);
    text(restartGame, newGameSize+border, yOffset);
    
    fill(195, 215, 222);
    rect(newGameSize+restartGameSize, 0, saveGameSize, barHeight);
    fill(0);
    text(saveGame, newGameSize+restartGameSize+border, yOffset);
    
    fill(195, 215, 222);
    rect(width-undoSize, 0, undoSize, barHeight);
    fill(0);
    text(undoMove, width+border-undoSize, yOffset);
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
