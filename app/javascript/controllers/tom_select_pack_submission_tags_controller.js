import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

export default class extends Controller {
  connect() {
    this.tomSelect = new TomSelect(this.element, {
      plugins: ['remove_button'],
      placeholder: 'Select Items',
      maxItems: 10
    })
    this.tomSelect.settings.placeholder = ""
  }
}
