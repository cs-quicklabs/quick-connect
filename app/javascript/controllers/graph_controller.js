import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";
import { drawContributions } from "../github-canvas";

export default class extends Controller {
  static targets = ["graph"];

  connect() {
    console.log("connected");

    get("/aashishdhawan.json", {
      responseKind: "application/json",
    })
      .then((response) => response.json)
      .then((response) => {
        this.contributionData = response;
        console.log(this.contributionData);
        console.log(this.graphTarget);
        drawContributions(this.graphTarget, {
          data: this.contributionData,
          username: "aashishdhawan",
          themeName: "standard",
          footerText: "Made by @sallar - github-contributions.now.sh",
          skipHeader: false,
        });
      });
  }
}
