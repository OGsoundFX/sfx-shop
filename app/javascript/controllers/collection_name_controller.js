import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["collectionName", "collectionNoName", "choseName", "nameForm", "nameChangeForm", "nameInputField", "newCollectionName", "replacedCollectionName"]

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

  nameChange(event) {
    this.replacedCollectionNameTarget.classList.add("d-none")
    if (event.target.id === "collection-no-name") {
      this.choseNameTarget.classList.add("d-none")
      this.nameChangeFormTarget.classList.remove("d-none")
    }
    else {
      this.nameChangeFormTarget.classList.remove("d-none")
    }
  }

  nameInput() {
    this.replacedCollectionNameTarget.classList.remove("d-none")
    this.nameChangeFormTarget.classList.add("d-none")
    this.replacedCollectionNameTarget.innerText = this.nameInputFieldTarget.value

    if (this.nameInputFieldTarget.value === "") {
      this.choseNameTarget.classList.remove("d-none")
    }
  }

  newNameInput() {
    this.nameFormTarget.classList.add("d-none")
    this.newCollectionNameTarget.innerText = this.nameInputFieldTarget.value
    if (this.nameInputFieldTarget.value === "") {
      this.choseNameTarget.classList.remove("d-none")
    }
  }
}

