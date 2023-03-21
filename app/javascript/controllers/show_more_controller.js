import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['truncate', 'full', 'button']

    toggle() {

        const truncatedText = this.truncateTarget;
        const fullText = this.fullTarget;
        const button = this.buttonTarget;
  
      if (truncatedText.style.display === 'none') {
        truncatedText.style.display = 'inline';
        fullText.style.display = 'none';
        button.textContent = 'Show more';
      } else {
        truncatedText.style.display = 'none';
        fullText.style.display = 'inline';
        button.textContent = 'Show less';
      }
    }
}