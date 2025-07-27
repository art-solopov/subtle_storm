// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

import {SiteSidebar} from 'elements/site_sidebar'

customElements.define('site-sidebar', SiteSidebar)
