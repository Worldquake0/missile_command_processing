

/*****************************************************************************
 *
 * Class name: SoundFx
 * Purpose: SoundFx class used for playing audio files.
 *          
 *
 *****************************************************************************/


private class SoundFx {
  AudioPlayer player;


/******************************************************************************
 *
 * Function name: soundFX
 * Purpose: Sounds class constructor.
 * Arguments: p: This is a PApplet.
 *            filename: This is a string for the name of the audio file.
 *            gain: This is a float to set the gain or loudness of the audio.
 * Return: 
 *
 *
 ******************************************************************************/


  public SoundFx(PApplet p, String filename, float gain) {
    minim = new Minim(p);
    player = minim.loadFile(filename);

    if (gain < 0) {
      player.setGain(gain);
    }
  }


/*****************************************************************************
 *
 * Function name: play
 * Purpose: To play the audio files.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


  private void play() {
    rewind();
    player.play();
  }


/*****************************************************************************
 *
 * Function name: loop
 * Purpose: To continuously play audio files in a loop.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


  private void loop() {
    player.loop();
  }


/*****************************************************************************
 *
 * Function name: rewind
 * Purpose: Used to rewind the audio file.
 * Arguments: n/a
 * Return: void
 *
 *****************************************************************************/


  private void rewind() {
    if (player.isPlaying()) {
      player.pause();
      player.rewind();
    }
    if (player.position() == player.length()) {
      player.rewind();
    }
  }
}
