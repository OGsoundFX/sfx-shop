import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "caretUp", "caretDown", "ascDesc" ]

  connect() {
  }
  
  toggleCaret(event) {
    this.caretUpTarget.classList.toggle("caret-active");
    this.caretDownTarget.classList.toggle("caret-active");
    if(event.currentTarget.dataset.order === "asc") {
      this.ascDescTarget.value = "asc";
    } else if(event.currentTarget.dataset.order === "desc") {
      this.ascDescTarget.value = "desc";
    }
  }
}
