import ApplicationController from './application_controller.js'
import consumer from "../channels/consumer"

export default class extends ApplicationController {
  increment(event) {
    consumer.connection.open()
    let element = document.querySelector("meta[name='current-account']")
    if (element == null) return
    this.current_account = element.getAttribute('content')
    window.addEventListener('page:change', function(event) {
    this.stimulate('Batch#show', event.target)
    });
  }
}