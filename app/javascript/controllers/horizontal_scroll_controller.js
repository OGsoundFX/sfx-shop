import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["scrollContainer", "leftArrow", "rightArrow"]

  connect() {
    console.log(this.scrollContainerTarget, this.leftArrowTarget, this.rightArrowTarget)
    this.scrollContainerTarget.addEventListener('scroll', this.#updateArrows.bind(this));
    this.#updateArrows()
  }

  leftArrowMove() {
    this.scrollContainerTarget.scrollBy({ left: -340, behavior: 'smooth' });
  }

  rightArrowMove() {
    this.scrollContainerTarget.scrollBy({ left: 340, behavior: 'smooth' });
  }

  #updateArrows() {
    if (this.scrollContainerTarget.scrollLeft === 0) {
      this.leftArrowTarget.style.display = 'none';
    } else {
      this.leftArrowTarget.style.display = 'block';
    }

    if (this.scrollContainerTarget.scrollWidth - this.scrollContainerTarget.clientWidth === this.scrollContainerTarget.scrollLeft) {
      this.rightArrowTarget.style.display = 'none';
    } else {
      this.rightArrowTarget.style.display = 'block';
    }
  }
}
