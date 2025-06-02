import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["collectionModal", "downloadModal", "modalText", "loading"]

  connect() {
  }

  modalDisplay() {
    this.collectionModalTarget.style.display = "block";
  }

  modalClose() {
    this.collectionModalTarget.style.display = "none";
  }

  download() {
    this.downloadModalTarget.style.display = "block";
    // fetch(event.currentTarget.href)
    //   .then(response => response.blob())
    //   .then(() => {
    //     this.modalTextTarget.innerText = "Your file have been zipped! Your download link will be available shortly.";
    //     this.modalTextTarget.parentElement.style.marginBottom = "0px";
    //     this.loadingTarget.style.display = "none";
    //   });
  }

  downloadModalClose() {
    this.downloadModalTarget.style.display = "none";
  }
}