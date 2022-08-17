import ApplicationController from './application_controller.js'
import consumer from "../channels/consumer"

export default class extends ApplicationController {
  increment(event) {
    consumer.connection.open()
    let element = document.querySelector("meta[name='current-user']")
    if (element == null) return
    this.current_user = element.getAttribute('content')
    if (window.history) {
      var myOldUrl = window.location.href;
      window.addEventListener('hashchange', function(){
    this.stimulate('Batch#show', event.target)
    })};
  }
}