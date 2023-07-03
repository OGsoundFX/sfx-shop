import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["dropdown", "filterList", "fantasy", "points", "duration", "pill"]

  connect() {
  }

  filtersArray(event) {
    if (event.currentTarget.dataset.filter === "fantasy") {
      if (event.currentTarget.dataset.clicked === "true") {
        event.currentTarget.dataset.clicked = "false";
        event.currentTarget.classList.toggle("pill-clicked");
      } else {
        this.fantasyTargets.forEach((filter) => {
          filter.classList.remove("pill-clicked");
          filter.dataset.clicked = "false";
        })
        event.currentTarget.dataset.clicked = "true";
        event.currentTarget.classList.toggle("pill-clicked");
      }
    } else if (event.currentTarget.dataset.filter === "points") {
      if (event.currentTarget.dataset.clicked === "true") {
        event.currentTarget.dataset.clicked = "false";
        event.currentTarget.classList.toggle("pill-clicked");
      } else {
        this.pointsTargets.forEach((filter) => {
          filter.classList.remove("pill-clicked");
          filter.dataset.clicked = "false";
        })
        event.currentTarget.dataset.clicked = "true";
        event.currentTarget.classList.toggle("pill-clicked");
      }
    } else {
      event.currentTarget.classList.toggle("pill-clicked");
      if (event.currentTarget.dataset.clicked === "true") {
        event.currentTarget.dataset.clicked = "false";
      } else {
        event.currentTarget.dataset.clicked = "true";
      }
    }

    const filterArray = []
    this.pillTargets.forEach((pill) => {
      if (pill.dataset.clicked === "true") {
        filterArray.push(pill.dataset.filterSpec)
      }
    })
    console.log(filterArray)
  }
}
