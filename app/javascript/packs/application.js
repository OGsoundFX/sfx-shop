// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import "bootstrap";

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import WaveSurfer from 'wavesurfer.js';

window.addEventListener('DOMContentLoaded', () => {
  var wavesurfer = WaveSurfer.create({
    container: '#wave',
    barWidth: 2,
    barHeight: 1,
    barGap: null,
    waveColor: '#CCCCCC',
    progressColor: '#FFA500'
  });

  // wavesurfer.on('ready', function () {
  //   wavesurfer.play();
  // });

  const trackLink = document.getElementById('trackLink').innerText;
  wavesurfer.load(trackLink);

  const playButton = document.getElementById('play');
  const stopButton = document.getElementById('stop');
  playButton.addEventListener('click', () => {
    playButton.style.display = "none";
    stopButton.style.display = "";
    wavesurfer.play();
  })
  stopButton.addEventListener('click', () => {
    stopButton.style.display = "none";
    playButton.style.display = "";
    wavesurfer.pause();
  })
});

// multiple track display

window.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.wave').forEach((el) => {
    var wavesurfer = WaveSurfer.create({
      container: '.wave',
      barWidth: 2,
      barHeight: 1,
      barGap: null,
      waveColor: '#CCCCCC',
      progressColor: '#FFA500'
    });
    wavesurfer.load('https://www.ogsoundfx.com/NeWsfXsHoPbAmSfx/testing/Aggressive_Beast_4.mp3');
    wavesurfer.on('ready', function () {
      wavesurfer.play();
    });
  })
});