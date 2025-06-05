import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="delete-job"
export default class extends Controller {
  static values = {
    jobId: String
  }

  delete() {
    fetch(`/jobs/${this.jobIdValue}`, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": document.querySelector("[name=csrf-token]").content
      }
    })
  } 
}
