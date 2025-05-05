import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["packsUnwrapped", "packsWrapped", "singleUnwrapped", "singleWrapped", "collectionWrapped", "collectionUnwrapped", "templateWrapped", "templateUnWrapped", "youSpare"]

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
      this.youSpareTarget.classList.toggle("d-none")
      this.collectionUnwrappedTarget.classList.toggle("d-none")
      this.collectionWrappedTarget.classList.toggle("d-none")
    }
  }

  templateWrap(event) {
    this.templateWrappedTargets.forEach((template) => {
      if (template.dataset.id == event.currentTarget.dataset.id) {
        template.classList.toggle("d-none")
      }
    })
    this.templateUnWrappedTargets.forEach((template) => {
      if (template.dataset.id == event.currentTarget.dataset.id) {
        template.classList.toggle("d-none")
      }
    })
  }

}