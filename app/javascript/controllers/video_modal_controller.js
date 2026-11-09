import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["button", "videoModal", "video", "close"]

  openModal(event) {
    event.preventDefault()
    this.videoModalTarget.style.display = "flex"
    this.videoModalTarget.setAttribute("aria-hidden", "false")
    this.closeTarget.focus()
    this.videoTarget.play().catch(error => {
      console.error("Could not play the Pack Builder demo video:", error)
    })
  }

  closeModal() {
    this.videoModalTarget.style.display = "none"
    this.videoModalTarget.setAttribute("aria-hidden", "true")
    this.videoTarget.pause()
    this.videoTarget.currentTime = 0
    this.buttonTarget.focus()
  }

  closeOnOutsideClick(event) {
    if (event.target === this.videoModalTarget) this.closeModal()
  }

  closeOnEscape(event) {
    if (event.key === "Escape" && this.videoModalTarget.getAttribute("aria-hidden") === "false") {
      this.closeModal()
    }
  }

}
