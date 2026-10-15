import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rich-text"
export default class extends Controller {
  connect() {
    document.addEventListener("trix-initialize", (event) => {
      const toolbar = event.target.toolbarElement

      // Remove specific buttons
      toolbar.querySelector('[data-trix-button-group="file-tools"]').remove()
      toolbar.querySelector('trix-toolbar [data-trix-attribute="strike"]').remove()
      toolbar.querySelector('trix-toolbar [data-trix-attribute="code"]').remove()
    })
  }
}
