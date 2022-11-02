import ApplicationController from './application_controller.js'

export default class extends ApplicationController {
  static targets = [ "groups" ]

  change(event) {
    var array = []
var checkboxes = document.querySelectorAll('input[type=checkbox]:checked')


for (var i = 0; i < checkboxes.length; i++) {
  array.push("<p class='mb-1 inline-flex items-center whitespace-nowrap px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 ml-2'>"+checkboxes[i].id+"</p>")
}
this.groupsTarget.innerHTML = array
  }
}

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}
