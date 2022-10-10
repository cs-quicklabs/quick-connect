import { Controller } from "@hotwired/stimulus"



export default class extends Controller {

    close() {
        this.element.remove()
    }

    escClose(event) {
        if (event.key === 'Escape') this.close()
     
    }
    clickOutside(event) {
      // example to close a modal
      event.preventDefault()
      this.element.remove()
    }

}