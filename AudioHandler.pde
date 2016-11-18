/*
 *   Class used to handle in-game audio
 */
import ddf.minim.*;
class AudioHandler{

  String[] songs = {"patiosIntro.mp3","patiosMid1.mp3","patiosMid2.mp3","patiosMid2.mp3","patiosIntermission1.mp3"}; // Place holder song, unreleased track by Long Season https://soundcloud.com/looong-season/
  Minim m; // Minim object
  AudioPlayer song; // Song that will play
  
  AudioHandler(Object main){
    m = new Minim(main);
  }
  
  void update(){
    if(intermissionTimer == 300){
      song.pause();
      song = m.loadFile(songs[4]);
      song.play();
    }else if(song == null || !song.isPlaying() && !song.isLooping()){
      if(curStage == SPLASH_SCREEN){
        song = m.loadFile(songs[0]);
        song.play();
      }
      if(curStage == BULLET_HELL){
        song = m.loadFile(songs[1]);
        song.loop();
      }
      if(curStage == SCROLLER_HELL)
      {
        song = m.loadFile(songs[2]);
        song.loop();
      }
      if(curStage == BOSS_HELL)
      {
        song = m.loadFile(songs[3]);
        song.loop();
      }
    }
  }
  
  void pause(){
    if(song!=null) song.pause();
  }
}