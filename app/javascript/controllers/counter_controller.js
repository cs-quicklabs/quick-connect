import ApplicationController from './application_controller.js'
import consumer from "../channels/consumer"

export default class extends ApplicationController {
  increement(event) {
   
    let element = document.querySelector("meta[name='current-user']")
    if (element == null) return
    this.current_user = element.getAttribute('content')
    consumer.connection.open()
    console.log('contact-id='+event.target.getAttribute("data-reflex-dataset"))
    this.stimulate('Batch#show','contact-id='+event.target.getAttribute("data-reflex-dataset"))
  }
}