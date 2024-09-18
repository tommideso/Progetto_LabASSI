// Import and register all your controllers from the importmap under controllers/*
// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

import { application } from "controllers/application";
import Notification from "@stimulus-components/notification";
import PlacesAutocomplete from "stimulus-places-autocomplete";
import { Tabs, Dropdown } from "tailwindcss-stimulus-components";
import RailsNestedFormController from "controllers/rails-nested_form_controller";
import Flatpicker from "./flatpickr_controller";

application.register("notification", Notification);
application.register("places-autocomplete", PlacesAutocomplete);
application.register("tabs", Tabs);
application.register("nested-form", RailsNestedFormController);
application.register("dropdown", Dropdown);
application.register("flatpickr", Flatpicker);
