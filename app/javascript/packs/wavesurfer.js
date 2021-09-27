import WaveSurfer from 'wavesurfer.js';

// multiple track display

window.addEventListener('DOMContentLoaded', () => {
  // loading watermark
  let watermark = new Audio('https://single-track-list.s3.eu-central-1.amazonaws.com/watermark/watermark.mp3');
  // creates an empty array which will be implemented with every container id (see push() function bellow)
  let wavesurfers = [];
  // creating undefined variable to be used in play() function and store the current file playing (if any)
  let audioPlaying;
  //inserting wavesurferplayer
  document.querySelectorAll('.wave').forEach((el, loopId) => {
    let id = el.id;
    wavesurfers.push(id);
    let link = el.dataset.link;
    wavesurfers[loopId] = WaveSurfer.create({
      container: `#${id}`,
      barWidth: 2,
      barHeight: 1,
      barGap: null,
      waveColor: '#CCCCCC',
      progressColor: '#FFA500',
      height: 50
    });
    // loading wavesurfer
    wavesurfers[loopId].load(link);

    // display track duration in index view
    wavesurfers[loopId].on('ready', () => {
      document.getElementById(`trackDuration${id}`).innerText = wavesurfers[loopId].getDuration();
    })

    // play and pause buttons
    let playButton = document.getElementById(`play${id}`);
    let stopButton = document.getElementById(`stop${id}`);

    playButton.addEventListener('click', () => {
      // stop watermark if any
      watermark.pause();
      // this will stop any audio playing when pressing start
      if (audioPlaying != undefined) {
        audioPlaying.stop()
      };
      playButton.style.display = "none";
      stopButton.style.display = "";
      wavesurfers[loopId].play();
      // this re-assigns the current file playing to the variable audioPlaying (every time you press play)
      audioPlaying = wavesurfers[loopId];
      // get duration of audio
      const duration = audioPlaying.getDuration()
      
      // play watermark and stop watermark
      if (duration < 3) {
        watermark.play()
      } else {
        watermark.play()
        let interval = setInterval(() => {
          watermark.play()
          if (!wavesurfers[loopId].isPlaying()) {
            clearInterval(interval);
          }
        }, 8000)
      }
    });

    // making sure button play stays on play when clicking waveform
    wavesurfers[loopId].on('play', function () {
      stopButton.style.display = "";
      playButton.style.display = "none";
    });

    stopButton.addEventListener('click', () => {
      stopButton.style.display = "none";
      playButton.style.display = "";
      wavesurfers[loopId].pause();
    })

    // swaps icon from play to pause automatically when track reaches the end
    wavesurfers[loopId].on('pause', function () {
      stopButton.style.display = "none";
      playButton.style.display = "";
    });
  })
  
  // stop audio playing before leaving page
  window.addEventListener('beforeunload', (event) => {
    event.preventDefault();
    audioPlaying.stop();
  });
});