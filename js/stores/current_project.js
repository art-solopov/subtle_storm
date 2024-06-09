import { atom } from 'nanostores'

export const $currentProject = atom(null)

export function updater() {
    const { currentProject } = window.top_content.dataset
    $currentProject.set(currentProject)
}
