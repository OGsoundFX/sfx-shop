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

  download(event) {
    console.log(event.currentTarget.href);
    this.downloadModalTarget.style.display = "block";
    fetch(event.currentTarget.href)
      .then(response => response.blob())
      .then(() => {
        console.log(navigator);
        this.modalTextTarget.innerText = "Your collection has been zipped! Your download will begin shortly.";
        this.modalTextTarget.parentElement.style.marginBottom = "0px";
        this.loadingTarget.style.display = "none";
        // setTimeout(() => {
        //   this.modalTextTarget.innerText = "Thank You!";
        //   this.modalTextTarget.style.fontSize = "24px";
        // }, 4000);
      });
  }

  downloadModalClose() {
    this.downloadModalTarget.style.display = "none";
  }
}