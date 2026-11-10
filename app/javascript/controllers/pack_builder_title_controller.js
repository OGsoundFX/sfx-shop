import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pack-builder-title"
export default class extends Controller {
  static values = {
    collectionId: Number
  }
  static targets = ["editIcon", "nameForm", "nameDisplay", "pressEnter"]

  connect() {
    console.log(this.nameFormTarget.action)
  }
  
  displayInput() {
    this.nameFormTarget.classList.remove("d-none")
    this.editIconTarget.classList.add("d-none")
    this.nameDisplayTarget.classList.add("d-none")
    this.pressEnterTarget.classList.remove("d-none")
  }
}
