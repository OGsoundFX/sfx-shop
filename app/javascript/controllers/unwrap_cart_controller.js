import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["packsUnwrapped", "packsWrapped", "singleUnwrapped", "singleWrapped", "collectionWrapped", "collectionUnwrapped"]

  connect() {
  }

  wrap(event) {
    if(event.target.id === "pack-arrow") {
      this.packsUnwrappedTarget.classList.toggle("d-none")
      this.packsWrappedTarget.classList.toggle("d-none")
    } else if (event.target.id === "single-arrow") {
      this.singleUnwrappedTarget.classList.toggle("d-none")
      this.singleWrappedTarget.classList.toggle("d-none")
    } else if (event.target.id === "collection-arrow") {
      this.collectionUnwrappedTarget.classList.toggle("d-none")
      this.collectionWrappedTarget.classList.toggle("d-none")
    }
  }

}