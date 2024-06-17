import { atom, task, onMount } from 'nanostores'

import * as projectsRepo from '../repo/projects'

export const $currentProjectKey = atom(null)
export const $currentProject = atom(null)

function loadKeyFromTopContent() {
    const { currentProject } = window.top_content.dataset
    $currentProjectKey.set(currentProject)
}

onMount($currentProjectKey, () => {
    loadKeyFromTopContent()
    document.addEventListener('htmx:afterSettle', loadKeyFromTopContent)

    return () => {
        document.removeEventListener('htmx:afterSettle', loadKeyFromTopContent)
    }
})

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
