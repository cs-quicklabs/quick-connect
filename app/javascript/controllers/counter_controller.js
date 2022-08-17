import ApplicationController from './application_controller.js'

export default class extends ApplicationController {
  increment(event) {
    consumer.connection.open()
    this.stimulate('Batch#show', event.target)
  }
}