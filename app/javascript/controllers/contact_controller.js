import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["labels", "favorite"]

    add_label(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId
        const labelId = event.currentTarget.dataset.id

        let element = document.querySelector("meta[name='current-account']");
        let current_account = element.getAttribute("content");

        fetch(`/${current_account}/contacts/${contactId}/labels`, {
            method: "POST",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/html"
            },
            body: new URLSearchParams({ id: labelId })
        })
            .then(response => response.text())
            .then(html => { localtion.reload() })
    }

    remove_label(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId
        const labelId = event.currentTarget.dataset.id

        let element = document.querySelector("meta[name='current-account']");
        let current_account = element.getAttribute("content");


        fetch(`/${current_account}/contacts/${contactId}/labels/${labelId}`, {
            method: "DELETE",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/vnd.turbo-stream.html"
            }
        })
            .then(response => response.text())
            .then(html => { location.reload() })
    }

    toggle_favorite(event) {
        let element = document.querySelector("meta[name='current-account']");
        let current_account = element.getAttribute("content");


        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId

        fetch(`/${current_account}/contacts/${contactId}/toggle_favorite`, {
            method: "PATCH",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/vnd.turbo-stream.html"
            }
        })
            .then(response => response.text())
            .then(html => { this.favoriteTarget.innerHTML = html })
    }
}