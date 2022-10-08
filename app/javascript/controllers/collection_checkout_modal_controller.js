import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["collectionModal", "downloadModal"]

  connect() {
  }

  modalDisplay() {
    this.collectionModalTarget.style.display = "block";
  }

  modalClose() {
    this.collectionModalTarget.style.display = "none";
  }

  download() {
    console.log(XMLHttpRequestEventTarget)
    this.downloadModalTarget.style.display = "block";
  }

  downloadModalClose() {
    this.downloadModalTarget.style.display = "none";
  }
}