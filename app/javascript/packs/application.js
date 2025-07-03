// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

require("@rails/ujs").start()
// removed turbolinks to be able to stop all sounds: see window.addEventlistener('beforeunload', callback());
// require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import './wavesurfer';
import './modals';
// import './responsive';
import "controllers"

import "@hotwired/turbo-rails"
