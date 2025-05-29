import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "modal" ]

  connect() {
  }

  close() {
    this.modalTarget.classList.add("d-none")
  }
}