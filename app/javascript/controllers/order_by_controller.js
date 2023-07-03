import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "caretUp", "caretDown", "ascDesc", "carets" ]

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

  removeAsc(event) {
    if(event.currentTarget.value === "newest") {
      this.caretUpTarget.classList.add("d-none");
      this.caretDownTarget.classList.add("d-none");
    } else {
      this.caretUpTarget.classList.remove("d-none");
      this.caretDownTarget.classList.remove("d-none");
      this.caretsTarget.classList.remove("d-none");
      this.caretsTarget.classList.add("d-flex");
    }
  }
}
