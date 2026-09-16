import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="designer-submission-filter"
export default class extends Controller {
  static targets = ["count", "tab", "submission"]

  connect() {
    let count = 0
    this.submissionTargets.forEach((submission) => {
      count ++
      if (submission.dataset.status === "accepted" || submission.dataset.status === "rejected") {
        submission.classList.add("d-none")
        count --
      }
    })
    this.countTarget.innerText = count
  }

  filter(event) {
    event.currentTarget.classList.add("btn-admin-active")
    this.tabTargets.forEach((tab) => {
      if (tab !== event.currentTarget) {
        tab.classList.remove("btn-admin-active")
      }
    })

    const selectedStatus = event.currentTarget.dataset.status
    let count = 0
    this.submissionTargets.forEach((submission) => {
      const isDisplayed = selectedStatus === "pending"
        ? submission.dataset.status !== "accepted" && submission.dataset.status !== "rejected"
        : submission.dataset.status === selectedStatus

      submission.classList.toggle("d-none", !isDisplayed)
      if (isDisplayed) {
        count++
      }
    })

    this.countTarget.innerText = count
  }
}
