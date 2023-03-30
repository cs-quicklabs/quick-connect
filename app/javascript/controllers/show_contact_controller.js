import { Controller } from "@hotwired/stimulus"
import StimulusReflex from 'stimulus_reflex';

export default class extends Controller {
  static targets = ['selected'];

  connect() {
    StimulusReflex.register(this);
  }


 toggleSelected(event) {
  event.preventDefault();
  const selected = this.selectedTargets.find((item) => item.dataset.selected === 'true');

 const item=event.target.closest('li')
 item.dataset.selected = 'true';
 item.classList.remove('bg-white');
 item.classList.add('bg-gray-50');

 if (selected)
 {
  console.log(selected.classList)
  selected.dataset.selected = 'false';
  selected.classList.remove('bg-gray-50');
  selected.classList.add('bg-white');

  this.stimulate('ContactReflex#show', item.dataset.contactId);
 }
  else
  {

  this.stimulate('ContactReflex#show', item.dataset.contactId);
  }



}
}