import { atom, task, onMount } from 'nanostores'

import { index } from '../repo/projects'

export const $projects = atom([])

export function loadProjects() {
    return task(async() => {
        $projects.set(await index())
    })
}

onMount($projects, loadProjects)
