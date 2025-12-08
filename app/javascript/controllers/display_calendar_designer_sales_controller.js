import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="display-calendar-designer-sales"
export default class extends Controller {
  static targets = ["dates", "calendar", "reset"]

  calendar() {
    this.datesTarget.classList.add("d-none")
    this.resetTarget.classList.add("d-none")
    this.calendarTarget.classList.remove("d-none")
  }
}
