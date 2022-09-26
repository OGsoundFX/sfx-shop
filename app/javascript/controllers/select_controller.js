import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "order", "title", "size", "price_cents", "points", "newest" ]

  connect() {
    this.targets.find(this.orderTarget.value).setAttribute('selected', '')
  }
}