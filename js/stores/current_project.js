import { atom, batched, task } from 'nanostores'
import { index as tasksIndex } from '../repo/tasks'

export const $currentProject = atom(null)

export const $currentProjectTasks = batched($currentProject, project => task(async () => {
    if(!project) { return [] }

    return tasksIndex(project)
}))

export function updater() {
    const { currentProject } = window.top_content.dataset
    $currentProject.set(currentProject)
}
