import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["labels", "favorite"]

    add_label(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId
        const labelId = event.currentTarget.dataset.labelId

        fetch(`/contacts/${contactId}/labels`, {
            method: "POST",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/vnd.turbo-stream.html"
            },
            body: new URLSearchParams({ label_id: labelId })
        })
            .then(response => response.text())
            .then(html => { this.labelsTarget.innerHTML = html })
    }

    remove_label(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId
        const labelId = event.currentTarget.dataset.labelId

        fetch(`/contacts/${contactId}/labels/${labelId}`, {
            method: "DELETE",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/vnd.turbo-stream.html"
            }
        })
            .then(response => response.text())
            .then(html => { this.labelsTarget.innerHTML = html })
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


    export(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId

        fetch(`/contacts/${contactId}/export`, {
            method: "GET",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/csv"
            }
        })
            .then(response => response.blob())
            .then(blob => {
                const url = window.URL.createObjectURL(blob)
                const a = document.createElement("a")
                a.href = url
                a.download = `contact_${contactId}.csv`
                document.body.appendChild(a)
                a.click()
                a.remove()
            })
    }

    add_relation(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId
        const relationType = event.currentTarget.dataset.relationType
        const relatedContactId = event.currentTarget.dataset.relatedContactId
        const formData = new URLSearchParams({
            relation_type: relationType,
            related_contact_id: relatedContactId
        })
        fetch(`/contacts/${contactId}/relations`, {
            method: "POST",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/vnd.turbo-stream.html"
            },
            body: formData
        })
            .then(response => response.text())
            .then(html => { this.labelsTarget.innerHTML = html })
    }

    remove_relation(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId
        const relationId = event.currentTarget.dataset.relationId

        fetch(`/contacts/${contactId}/relations/${relationId}`, {
            method: "DELETE",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/vnd.turbo-stream.html"
            }
        })
            .then(response => response.text())
            .then(html => { this.labelsTarget.innerHTML = html })
    }

    change_relation(event) {
        event.preventDefault()
        const contactId = event.currentTarget.dataset.contactId
        const relationId = event.currentTarget.dataset.relationId
        const newRelationType = event.currentTarget.value

        fetch(`/contacts/${contactId}/relations/${relationId}`, {
            method: "PATCH",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/vnd.turbo-stream.html"
            },
            body: new URLSearchParams({ relation_type: newRelationType })
        })
            .then(response => response.text())
            .then(html => { this.labelsTarget.innerHTML = html })
    }

}