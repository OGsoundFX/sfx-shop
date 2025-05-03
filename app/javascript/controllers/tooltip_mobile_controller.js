import { Controller } from "stimulus"

export default class extends Controller {
  tooltipDisplay() {
    this.element.classList.add('show-tooltip')
    // Clear any previous timeout to prevent stacking
    if (this.element.hideTimeout) clearTimeout(this.element.hideTimeout);

    // Hide after 3 seconds
    this.element.hideTimeout = setTimeout(() => {
      this.element.classList.remove('show-tooltip');
    }, 1000);
    }
}