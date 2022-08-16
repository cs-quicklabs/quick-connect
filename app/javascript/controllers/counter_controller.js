import ApplicationController from './application_controller.js'

export default class extends ApplicationController {
  increment(event) {
    winddow.location('73/contacts/24/batches')
    this.stimulate('Batch#show', event.target)
  }
}