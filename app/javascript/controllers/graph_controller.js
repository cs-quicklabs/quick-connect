import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";
import { drawContributions } from "../github-canvas";

export default class extends Controller {
  static targets = ["graph"];
  static values = {
    url: String,
  };

  connect() {
    const type = this.urlValue.split("=")[1];

    get(this.urlValue, {
      responseKind: "application/json",
    })
      .then((response) => response.json)
      .then((response) => {
        this.contributionData = response;
        drawContributions(this.graphTarget, {
          data: this.contributionData,
          themeName: "standard",
          text: type ? type.replace("_", " ") : "ratings",
        });
      });
  }
}
