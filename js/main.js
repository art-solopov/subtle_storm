import {defineCustomElement, createApp} from 'vue'
import { logger } from '@nanostores/logger'

import Sidebar from './components/Sidebar.ce.vue'
import ProjectLoader from './components/ProjectLoader.vue'
import TasksTable from './components/TasksTable.vue'
import Home from './components/Home.vue'

import * as currentProjectStore from './stores/current_project'

import './assets/main.css'

customElements.define('s-sidebar', defineCustomElement(Sidebar))

const components = { ProjectLoader, Home, TasksTable }

function mountComponents() {
    for (let el of document.querySelectorAll('.vue-mount:empty')) {
        let vue = components[el.dataset.vue]
        if (!vue) continue


        const app = createApp(vue)
        app.mount(el)
        el.addEventListener('htmx:beforeSwap', () => {
            app.unmount()
        })

        htmx.process(el)
    }
}

const _destroy = logger({
    currentProjectKey: currentProjectStore.$currentProjectKey,
    currentProject: currentProjectStore.$currentProject
})

document.addEventListener('DOMContentLoaded', mountComponents)
document.addEventListener('htmx:afterSettle', mountComponents)
