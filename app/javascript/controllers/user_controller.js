import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["toggle"]


    toggle(event) {
        event.preventDefault()

        let element = document.querySelector("meta[name='current-account']");
        let current_account = element.getAttribute("content");
        let url = `/${current_account}/settings/preferences/toggle_email_notifications`

        fetch(url, {
            method: "PATCH",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                Accept: "text/vnd.turbo-stream.html",
            },

        }).then((response) => response.text()).then((response) => {
            this.toggleTarget.innerHTML = response;
        }
        ).catch((error) => {
            console.error("Error:", error);
        });
    }
}