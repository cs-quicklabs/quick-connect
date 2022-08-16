import ApplicationController from './application_controller.js'

export default class extends ApplicationController {
  increment(event) {
    window.location.assign('/73/batches')
    this.stimulate('Batch#show', event.target)
  }
}