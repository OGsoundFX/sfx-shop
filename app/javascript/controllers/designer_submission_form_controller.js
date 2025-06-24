import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="designer-submission-form"
export default class extends Controller {
  static targets = ["mainForm", "add", "form", "linkForm", "submissionInfo", "editForm", "editButton", "line"]

  displayForm(event) {
    event.preventDefault()
    const formValues = new FormData(this.mainFormTarget.closest("form"))
    event.currentTarget.classList.add("d-none")
    this.formTarget.classList.remove("d-none")
    const options = {
      method: "POST",
      body: formValues
    }
    fetch(this.mainFormTarget.action, options)
  }

  add(event) {
    event.preventDefault()
    console.log(new FormData(this.linkFormTarget.closest("form")).get("designer_submission[submission_links_attributes][0][url]"))
  }

  editForm(event) {
    event.preventDefault()
    this.submissionInfoTarget.remove()
    this.editFormTarget.classList.remove("d-none")
    this.editButtonTarget.remove()
    this.addTarget.remove()
    this.lineTarget.remove()
  }
}
