import WaveSurfer from 'wavesurfer.js';

// time converter function

const timeConverter = (time) => {
  if (time >= 1) {
    return new Date(time * 1000).toISOString().substr(14, 5)
  } else {
    return new Date(1000).toISOString().substr(14, 5)
  }
}

// multiple track display

window.addEventListener('DOMContentLoaded', () => {
  setTimeout(() => {
    // for loading the waveforms of collections display section in cart
    if (!!document.getElementById("collection-display")) {
      document.getElementById("collection-display").classList.add('d-none')
      document.getElementById("collection-display").style.visibility = ""
      document.getElementById("wrapped-collection-display").classList.remove('d-none')
    }

    // for loading the waveforms of single tracks display section in cart
    if (!!document.getElementById("single-display")) {
      document.getElementById("single-display").classList.add('d-none')
      document.getElementById("single-display").style.visibility = ""
      document.getElementById("wrapped-single-display").classList.remove('d-none')
    }
  }, 700);

  // loading watermark
  let watermark = new Audio('https://single-track-list.s3.eu-central-1.amazonaws.com/watermark/watermark.mp3');
  watermark.volume = 0.5;
  // creates an empty array which will be implemented with every container id (see push() function bellow)
  let wavesurfers = [];
  // creating undefined variable to be used in play() function and store the current file playing (if any)
  let audioPlaying;
  // creating an empty hash to store the loopId corresponding to the track.id
  let ids = {};
  //inserting wavesurferplayer
  document.querySelectorAll('.wave').forEach((el, loopId) => {
    let id = el.id;
    ids[loopId] = id
    wavesurfers.push(id);
    let link = el.dataset.link;
    wavesurfers[loopId] = WaveSurfer.create({
      container: `#${id}`,
      barWidth: 2,
      barHeight: 1,
      barGap: null,
      waveColor: '#CCCCCC',
      progressColor: '#FFA500',
      height: 50,
      cursorColor: '#FFA500',
      responsive: true
    });

    // display loading time when loading
    const UpdateLoadingFlag = (Percentage, id) => {
      if (document.getElementById(`loading_flag${id}`)) {
        document.getElementById(`loading_flag${id}`).innerText = "Loading " + Percentage + "%";
        if (Percentage >= 100) {
          document.getElementById(`loading_flag${id}`).style.display = "none";
        } else {
          document.getElementById(`loading_flag${id}`).style.display = "block";
        }
      }
    }
    // show progress while loading sound
    wavesurfers[loopId].on('loading', (X, evt) => {
      UpdateLoadingFlag(X, ids[loopId].substr(2));
    });

    // loading wavesurfer
    wavesurfers[loopId].load(link);

    // display track duration in index view
    wavesurfers[loopId].on('ready', () => {
      const trackSeconds = wavesurfers[loopId].getDuration();
      const trackDuration = timeConverter(trackSeconds);
      document.getElementById(`trackDuration${id}`).innerText = trackDuration;
      document.getElementById(`trackDurationModal${id}`).innerText = trackDuration;
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
      } else if (duration < 15) {
        watermark.play()

        // the reason why I chose this approach is for clearInterval() to be called within 1 second
        // rather than 8 seconds like before, when I set the interval to 8 seconds and we couls hear
        // another watermark eventhough the audio had stoped, up to 8 seconds after.
        let i = 1;
        let interval = setInterval(() => {
          i ++;
          if (i === 4) {
            watermark.play()
            i = 1;
          }
          if (!wavesurfers[loopId].isPlaying()) {
            clearInterval(interval);
          }
        }, 1000)
      } else {
        watermark.play()

        // the reason why I chose this approach is for clearInterval() to be called within 1 second
        // rather than 8 seconds like before, when I set the interval to 8 seconds and we could hear
        // another watermark eventhough the audio had stoped, up to 8 seconds after.
        let i = 1;
        let interval = setInterval(() => {
          i ++;
          if (i === 8) {
            watermark.play()
            i = 1;
          }
          if (!wavesurfers[loopId].isPlaying()) {
            clearInterval(interval);
          }
        }, 1000)
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