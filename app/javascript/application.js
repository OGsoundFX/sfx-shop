// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Legacy imports from the old Webpacker file
import "bootstrap";
import './packs/wavesurfer';
import './packs/modals';
// import './responsive'; // Uncomment if needed

// Rails UJS, Active Storage, and ActionCable Channels
import { start as startUJS } from "@rails/ujs"
import { start as startActiveStorage } from "@rails/activestorage"
// import "channels"

startUJS()
startActiveStorage()
