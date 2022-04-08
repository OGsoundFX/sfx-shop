import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["collectionName", "collectionNoName"]

  connect() {
    console.log("Hello from collection name controller")
  }

  name(event) {
    console.log(event.target.id)
    if (event.target.id === "collection-no-name") {
      this.collectionNameTarget.classList.remove("d-none")
      this.collectionNoNameTarget.classList.add("d-none")
    }
  }
}

