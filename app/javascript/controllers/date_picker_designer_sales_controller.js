import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="date-picker-designer-sales"
export default class extends Controller {

  connect() {
    flatpickr(this.element, {
      mode: "range",
      maxDate: "today",
      dateFormat: "Y.m.d",
    });
  }
}
