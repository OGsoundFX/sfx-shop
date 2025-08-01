import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

export default class extends Controller {
  static values = {
    placeholder: String
  }
  connect() {
    const displayPlaceholder = this.placeholderValue === "false" ? '' : 'Select Items'
    this.tomSelect = new TomSelect(this.element, {
      plugins: ['remove_button'],
      placeholder: displayPlaceholder,
      maxItems: 10
    })
    this.tomSelect.settings.placeholder = ""
  }
}
