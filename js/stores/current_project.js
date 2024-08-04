import { atom, task, onMount } from 'nanostores'

import * as projectsRepo from '../repo/projects'

export const $currentProjectKey = atom(null)
export const $currentProject = atom(null)

function loadKeyFromTopContent() {
    const { currentProject } = window.top_content.dataset
    $currentProjectKey.set(currentProject)
}

function loadKeyFromState(ev) {
    $currentProjectKey.set(ev.state.project)
}

onMount($currentProjectKey, () => {
    loadKeyFromTopContent()
    document.addEventListener('htmx:afterSettle', loadKeyFromTopContent)
    window.addEventListener('popstate', loadKeyFromState)

    return () => {
        document.removeEventListener('htmx:afterSettle', loadKeyFromTopContent)
        window.removeEventListener('popstate', loadKeyFromState)
    }
})

export function setProject(projectKey) {
    const prevProject = $currentProjectKey.get()
    history.replaceState({project: prevProject}, "")

    const url = new URL(window.location)
    url.searchParams.set('project', projectKey)
    $currentProjectKey.set(projectKey)
    history.pushState({project: projectKey}, "", url)
}

async function _reloadCurrentProject(key) {
    let projectData = null
    if(key) {
        projectData = await projectsRepo.show(key)
    }
    $currentProject.set(projectData)
}

onMount($currentProject, () => {
    const unsubCurrentProject = $currentProjectKey.subscribe(projectKey => task(async () => {
        _reloadCurrentProject(projectKey)
    }))

    return () => {
        unsubCurrentProject()
    }
})

export async function reloadCurrentProject() {
    return _reloadCurrentProject($currentProjectKey.get())
}
