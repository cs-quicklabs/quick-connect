import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selected", "details", "profile"];

  toggleSelected(event) {
    event.preventDefault();
    const selected = this.selectedTargets.find((item) => item.dataset.selected === "true");

    const item = event.target.closest("li");
    item.dataset.selected = "true";
    item.classList.remove("bg-white");
    item.classList.add("bg-gray-50");

    if (selected) {
      selected.dataset.selected = "false";
      selected.classList.remove("bg-gray-50");
      selected.classList.add("bg-white");
      const url = event.target.closest("a").href;

      fetch(url, { headers: { Accept: "text/vnd.turbo-stream.html" } })
        .then((response) => response.text())
        .then((html) => {
          this.detailsTarget.innerHTML = html;
        });
    } else {
      const url = event.target.closest("a").href;

      fetch(url, { headers: { Accept: "text/vnd.turbo-stream.html" } })
        .then((response) => response.text())
        .then((html) => {
          this.detailsTarget.innerHTML = html;
        });
    }
  }
}
