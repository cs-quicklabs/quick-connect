import { Controller } from "@hotwired/stimulus"
import { createPopper } from "@popperjs/core";

// Connects to data-controller="popper"
export default class extends Controller {
  static targets = ["element", "tooltip"];
  static values = {
    placement: { type: String, default: "top" },
    offset: { type: Array, default: [0, 8] },
  };

  connect() {
    // Create a new Popper instance
    this.popperInstance = createPopper(this.elementTarget, this.tooltipTarget, {
      placement: this.placementValue,
      modifiers: [
        {
          name: "offset",
          options: {
            offset: this.offsetValue,
          },
        },
      ],
    });
  }
  show(event) {
    this.tooltipTarget.setAttribute("data-show", "");

    // We need to tell Popper to update the tooltip position
    // after we show the tooltip, otherwise it will be incorrect
    this.popperInstance.update();
  }

  hide(event) {
    this.tooltipTarget.removeAttribute("data-show");
  }

  // Destroy the Popper instance
  disconnect() {
    if (this.popperInstance) {
      this.popperInstance.destroy();
    }
  }
}
