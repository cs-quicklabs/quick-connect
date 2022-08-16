import ApplicationController from './application_controller.js'

export default class extends ApplicationController {
  increment(event) {
    this.stimulate('Batch#show', event.target)
  }
}