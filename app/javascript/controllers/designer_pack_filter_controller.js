import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="designer-pack-filter"
export default class extends Controller {
  static targets = ["status", "pill", "count"]
  static values = {
    packCount: Object
  }
  
  connect() {
    console.log(this.packCountValue)
    this.statusValues = ["all", "live", "submitted", "declined", "drafts", "removed"]
  }

  filter(event) {
    // update the count number
    console.log(event.currentTarget.innerText)
    this.countTarget.innerText = `Count: ${this.packCountValue[event.currentTarget.innerText]}`

    // apply the active class to selected tab
    this.pillTargets.forEach((pill) => {
      pill.classList.remove("active")
    })
    event.currentTarget.classList.add("active")

    // display packs corresponding to active tab
    this.statusTargets.forEach((pack) => {
      if (pack.dataset.status === event.currentTarget.innerText || event.currentTarget.innerText === "all") {
        pack.classList.remove("d-none")
      } else {
        pack.classList.add("d-none")
      }
    })
  }
}
