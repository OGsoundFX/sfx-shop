import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

// Connects to data-controller="tom-select-country"
export default class extends Controller {
  connect() {
    this.tomSelect = new TomSelect(this.element)
  }
}
