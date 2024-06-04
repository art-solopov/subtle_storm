import {defineCustomElement, createApp} from 'vue'

import Sidebar from './components/Sidebar.ce.vue'
import ProjectLoader from './components/ProjectLoader.vue'

import './assets/main.css'

customElements.define('s-sidebar', defineCustomElement(Sidebar))

const components = { ProjectLoader }

function mountComponents() {
    for (let el of document.querySelectorAll('.vue-mount:empty')) {
        let vue = components[el.dataset.vue]
        if (!vue) continue
        createApp(vue).mount(el)
    }
}

document.addEventListener('DOMContentLoaded', mountComponents)
document.addEventListener('htmx:afterSwap', mountComponents)
