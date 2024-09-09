# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "infinite_scroll", to: "infinite_scroll.js"
pin "flatpickr" # @4.6.13
pin "@stimulus-components/notification", to: "@stimulus-components--notification.js" # @3.0.0
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "stimulus-use" # @0.52.2
