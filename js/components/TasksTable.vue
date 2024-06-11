<script setup>
    import { ref, watch } from 'vue'
    import { useStore } from '@nanostores/vue'

    import { $currentProject, $currentProjectTasks } from '../stores/current_project'
    import { index } from '../repo/tasks'

    const currentProject = useStore($currentProject)
    const tasks = useStore($currentProjectTasks)

    function formatTaskNumber(task) {
        let project = task.project.toUpperCase()
        return `${project}-${task.number}`
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
