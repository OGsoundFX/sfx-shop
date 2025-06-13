import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-review"
export default class extends Controller {
  static targets = ["reviewContent"]
  toggle(event) {
    event.currentTarget.innerText === "Close" ? event.currentTarget.innerText = "Read review" : event.currentTarget.innerText = "Close"
    this.reviewContentTarget.classList.toggle("d-none")
  }
}
