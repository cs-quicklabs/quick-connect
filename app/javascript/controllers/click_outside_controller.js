import { ClickOutsideController } from 'stimulus-use'
import { useClickOutside } from 'stimulus-use'

export default class extends ClickOutsideController {
  connect() {
    useClickOutside(this)
  }
  clickOutside(event) {
    // example to close a modal
    console.log('click')
    event.preventDefault()
    this.close()
  }
}