// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"
import { Application } from '@hotwired/stimulus';

import ApplicationController from "./application_controller.js"
application.register("application", ApplicationController)

import ConfirmationController from "./confirmation_controller.js"
application.register("confirmation", ConfirmationController)

import CounterController from "./counter_controller.js"
application.register("counter", CounterController)

import DropdownController from "./dropdown_controller.js"
application.register("dropdown", DropdownController)

import InfiniteScrollController from "./infinite_scroll_controller.js"
application.register("infinite-scroll", InfiniteScrollController)

import ModalController from "./modal_controller.js"
application.register("modal", ModalController)



import NavSearchController from "./nav_search_controller.js"
application.register("nav-search", NavSearchController)

import SelectController from "./select_controller.js"
application.register("select", SelectController)

import PopperController from "./popper_controller.js"
application.register("popper", PopperController)

import ToggleController from "./toggle_controller.js"
application.register("toggle", ToggleController)

import MultiSelectController from '@kanety/stimulus-multi-select';
import StimulusReflex from 'stimulus_reflex'
import consumer from '../channels/consumer'
import controller from '../controllers/application_controller'
import CableReady from 'cable_ready'
const app = Application.start();
app.register('multi-select', MultiSelectController);

application.consumer = consumer
StimulusReflex.initialize(application, { controller, isolate: true })
CableReady.initialize({ consumer })