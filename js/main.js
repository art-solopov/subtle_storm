import {defineCustomElement, createApp} from 'vue'
import { logger } from '@nanostores/logger'

import { $projects } from './stores/projects'
import { $currentProject, $currentProjectTasks, updater as currentProject_updater } from './stores/current_project'

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


        const app = createApp(vue)
        app.mount(el)
        el.addEventListener('htmx:beforeSwap', () => {
            app.unmount()
        })

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
    projects: $projects,
    currentProject: $currentProject,
    currentProjectTasks: $currentProjectTasks
})
