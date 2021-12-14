import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "dropdown", "action", "medieval", "outdoor", "underground", "scary", "monsters", "disasters", "weather" ]

  connect() {
    this.targets.find(this.dropdownTarget.value).setAttribute('selected', '')
  }
}

