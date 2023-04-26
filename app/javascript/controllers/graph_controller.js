import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";
import { drawContributions } from "../github-canvas";

export default class extends Controller {
  static targets = ["graph"];
  static values = {
    type: String,
  };

  connect() {
    console.log(this.typeValue.replace("_", " "));
    get("/report/activities.json?type=" + this.typeValue, {
      responseKind: "application/json",
    })
      .then((response) => response.json)
      .then((response) => {
        this.contributionData = response;
        drawContributions(this.graphTarget, {
          data: this.contributionData,
          themeName: "standard",
          text: this.typeValue.replace("_", " "),
        });
      });
  }
}
