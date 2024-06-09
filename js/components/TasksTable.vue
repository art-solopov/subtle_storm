<script setup>
    import { ref, watch } from 'vue'
    import { useStore } from '@nanostores/vue'

    import { $currentProject } from '../stores/current_project'
    import { index } from '../repo/tasks'

    const currentProject = useStore($currentProject)
    const tasks = ref([])


    watch(currentProject, async (project, prevProject) => {
        console.log(project, prevProject) 
        tasks.value = await index(project)
    }, { immediate: true })

    function formatTaskNumber(task) {
        let project = task.project.split('/').at(-1).toUpperCase()
        return `${project}-${task._key}`
    }
</script>

<template>
    <table>
        <thead>
            <tr>
                <th>Status</th>
                <th>Number</th>
                <th>Title</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="task in tasks">
                <td>{{ task.status.name }}</td>
                <td>{{ formatTaskNumber(task) }}</td>
                <td>{{ task.title }}</td>
            </tr>
        </tbody>
    </table>
</template>
