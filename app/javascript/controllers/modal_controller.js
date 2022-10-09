import { Controller } from "@hotwired/stimulus"

import { useClickOutside } from 'stimulus-use'

export default class extends Controller {
  connect() {
    useClickOutside(this)
  }
    close() {
        this.element.remove()
    }

    escClose(event) {
        if (event.key === 'Escape') this.close()
    }


}