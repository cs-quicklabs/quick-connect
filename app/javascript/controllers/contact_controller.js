import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

export default class extends Controller {
    static targets = ["labels", "favorite"]

    async add_label(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId
        const labelId = event.currentTarget.dataset.id

        let element = document.querySelector("meta[name='current-account']");
        let current_account = element.getAttribute("content");

        const request = new FetchRequest('post', `/${current_account}/contacts/${contactId}/labels`, { body: JSON.stringify({ id: labelId }), responseKind: 'turbo-stream' })
        const response = await request.perform()

    }

    async remove_label(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId
        const labelId = event.currentTarget.dataset.id

        let element = document.querySelector("meta[name='current-account']");
        let current_account = element.getAttribute("content");

        const request = new FetchRequest('DELETE', `/${current_account}/contacts/${contactId}/labels/${labelId}`, { responseKind: 'turbo-stream' })
        const response = await request.perform()

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