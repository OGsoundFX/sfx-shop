import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="designer-pack-filter"
export default class extends Controller {
  static targets = ["status", "pill"]
  static values = {
    status: String
  }
  
  connect() {
    this.statusValues = ["all", "live", "submitted", "declined", "drafts", "removed"]
  }

  filter(event) {
    this.pillTargets.forEach((pill) => {
      pill.classList.remove("active")
    })
    event.currentTarget.classList.add("active")

    this.statusTargets.forEach((pack) => {
      if (pack.dataset.status === event.currentTarget.innerText || event.currentTarget.innerText === "all") {
        pack.classList.remove("d-none")
      } else {
        pack.classList.add("d-none")
      }
    })
  }
}
