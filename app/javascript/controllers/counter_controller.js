import { Controller } from "@hotwired/stimulus";


export default class extends Controller {
  static targets = ["groups"];

  change(event) {
    var array = [];
    var checkboxes = document.querySelectorAll("input[type=checkbox]:checked");

    for (var i = 0; i < checkboxes.length; i++) {
      array.push("<span class='inline-flex items-center whitespace-nowrap px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 mb-2'>" + checkboxes[i].id + "</span>");
    }
    this.groupsTarget.innerHTML = array.join("");
  }
}
