import ApplicationController from './application_controller.js'
import consumer from "../channels/consumer"

export default class extends ApplicationController {
  increement(event) {
   
    let element = document.querySelector("meta[name='current-user']")
    if (element == null) return
    this.current_user = element.getAttribute('content')
    console.log(this.current_user)
    consumer.connection.open()
    this.stimulate('Batch#show', event.target.getAttribute("data-reflex-dataset"))
  }
}