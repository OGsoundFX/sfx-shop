import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "modal" ]

  connect() {
    console.log("hello")
  }

  close() {
    this.modalTarget.classList.add("d-none")
  }
}