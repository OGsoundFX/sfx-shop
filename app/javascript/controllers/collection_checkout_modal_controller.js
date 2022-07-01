import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["collectionModal"]

  connect() {
  }

  modalDisplay() {
    this.collectionModalTarget.style.display = "block";
  }

  modalClose() {
    this.collectionModalTarget.style.display = "none";
  }
}