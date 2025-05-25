import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    toggle(event) {
        event.preventDefault()
        const taskId = event.currentTarget.dataset.taskId
        let contact_id = event.currentTarget.dataset.contactId;

        let element = document.querySelector("meta[name='current-account']");
        let current_account = element.getAttribute("content");

        fetch(`/${current_account}/contacts/${contact_id}/tasks/${taskId}/toggle`, {
            method: "PATCH",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
                "Accept": "text/vnd.turbo-stream.html"
            }
        })
            .then(response => response.text())
            .then(html => {
                // Replace the task show partial with the updated HTML
                location.reload();
            })
    }
}