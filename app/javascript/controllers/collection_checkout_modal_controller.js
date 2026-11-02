import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["collectionModal", "downloadModal", "modalText", "loading"]
  static values = { statusUrl: String }

  connect() {
    this.disconnected = false
    if (this.element.querySelector(".loader")) this.checkDownloadStatus()
  }

  disconnect() {
    this.disconnected = true
    if (this.statusCheckTimeout) clearTimeout(this.statusCheckTimeout)
  }

  modalDisplay() {
    this.collectionModalTarget.style.display = "block";
  }

  modalClose() {
    this.collectionModalTarget.style.display = "none";
  }

  download() {
    this.downloadModalTarget.style.display = "block";
  }

  async checkDownloadStatus() {
    if (this.disconnected || !this.element.querySelector(".loader")) return

    try {
      const response = await fetch(this.statusUrlValue, {
        headers: { Accept: "text/vnd.turbo-stream.html" },
        credentials: "same-origin"
      })

      if (response.status === 204) {
        this.statusCheckTimeout = setTimeout(() => this.checkDownloadStatus(), 2000)
        return
      }

      if (!response.ok) throw new Error(`Download status check failed (${response.status})`)
      if (!window.Turbo) throw new Error("Turbo is not available to process the download update")

      window.Turbo.renderStreamMessage(await response.text())
    } catch (error) {
      console.error("Could not check zip download status:", error)
    }
  }

  downloadModalClose() {
    this.downloadModalTarget.style.display = "none";
  }
}