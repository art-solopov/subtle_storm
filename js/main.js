import {defineCustomElement, createApp} from 'vue'
import { logger } from '@nanostores/logger'

import { $currentProject, updater as currentProject_updater } from './stores/current_project'

import Sidebar from './components/Sidebar.ce.vue'
import ProjectLoader from './components/ProjectLoader.vue'
import TasksTable from './components/TasksTable.vue'
import Home from './components/Home.vue'

import './assets/main.css'

customElements.define('s-sidebar', defineCustomElement(Sidebar))

const components = { ProjectLoader, Home, TasksTable }

function mountComponents() {
    for (let el of document.querySelectorAll('.vue-mount:empty')) {
        let vue = components[el.dataset.vue]
        if (!vue) continue

        createApp(vue).mount(el)
        htmx.process(el)
    }
}

function updater() {
    currentProject_updater()
    mountComponents()
}

document.addEventListener('DOMContentLoaded', updater)
document.addEventListener('htmx:afterSettle', updater)

const destroy = logger({
    currentProject: $currentProject
})
