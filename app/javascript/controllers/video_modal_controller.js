import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["button", "videoModal", "close"]

  connect() {
  }
  
  openModal() {
    // console.log(this.buttonTarget, this.videoModalTarget, this.closeTarget)
    this.videoModalTarget.style.display = "block" 
  }
  
  closeModal() {
    this.videoModalTarget.style.display = "none"
  }

}
