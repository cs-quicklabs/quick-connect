import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["show", "unhide"];

  toggle() {
    this.element.addEventListener("click", function () {
      this.showTarget.style.display = "block";
    });
  }

  get value() {
    return this.showTarget;
  }
  get input() {
    return this.unhideTarget;
  }
}
