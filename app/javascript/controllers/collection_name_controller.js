import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["collectionName", "collectionNoName", "choseName", "nameForm", "nameInputField", "newCollectionName", "replacedCollectionName"]

  connect() {
  }

  name(event) {
    if (event.target.id === "collection-no-name") {
      this.choseNameTarget.classList.add("d-none")
      this.nameFormTarget.classList.remove("d-none")
    }
    else {
      this.nameFormTarget.classList.remove("d-none")
    }
  }

  nameInput() {
    this.nameFormTarget.classList.add("d-none")
    this.replacedCollectionNameTarget.innerText = this.nameInputFieldTarget.value
  }
}

