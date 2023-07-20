import { Controller } from "@hotwired/stimulus";
import tippy from "tippy.js";
import 'tippy.js/themes/light.css';
import  {roundArrow} from 'tippy.js';
import 'tippy.js/dist/svg-arrow.css';
import 'tippy.js/animations/scale.css';

export default class extends Controller {
    connect() {
        tippy(this.element, {
          allowHTML: true,
          theme: 'material',
          animation: 'fade',
          arrow: true,
          offset: [20, 5],
          content: this.element.getAttribute("data-tooltip-content"),
          trigger: 'mouseenter'
        });
      }
    }
