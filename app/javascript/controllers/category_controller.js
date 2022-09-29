import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "dropdown", "action", "medieval", "outdoor", "underground", "scary", "monsters", "disasters", "weather", "miscellaneous", "footsteps", "magic", "scifi" ]

  connect() {
    this.targets.find(this.dropdownTarget.value).setAttribute('selected', '')
    console.log(this.disastersTarget)
  }
}

