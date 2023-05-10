import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
 static values = { message: String }
 static targets = ["replace"]

  confirm(event) {
     event.preventDefault()
    if (!(window.confirm(this.messageValue))) {
     
      event.stopImmediatePropagation()
    } else{
      const url= event.target.href
      fetch(url, { headers: { Accept: "text/vnd.turbo-stream.html" } })
        .then((response) => response.text())
        .then((html) => {
          this.replaceTarget.innerHTML = html;
        });
        if (document.getElementById("profile")){
        document.querySelector("#profile1").remove();
        }
    }
  }
}
