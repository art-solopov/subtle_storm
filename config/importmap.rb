# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from 'app/javascript/elements', under: 'elements'
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin 'lit', to: 'lit-all-3.3.1.min.js'
