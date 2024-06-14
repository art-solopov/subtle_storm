<script setup>
    import { ref, watch, computed } from 'vue'
    import { useStore } from '@nanostores/vue'

    import { $currentProject } from '../stores/current_project'
    import { index } from '../repo/tasks'
    import TaskForm from './TaskForm.vue'

    const currentProject = useStore($currentProject)
    const tasks = ref([])
    const taskForEdit = ref(null)
    const taskEditDialog = ref()
    const showTaskForm = ref(false)

    async function reloadTasks(project) {
        tasks.value = await index(project)
    }

    watch(currentProject, async project => reloadTasks(project), { immediate: true })

    watch(showTaskForm, (stf) => { 
        if(stf) taskEditDialog.value.showModal()
    })

    function formatTaskNumber(task) {
        let project = task.project.toUpperCase()
        return `${project}-${task.number}`
    }

    function newTask() {
        taskForEdit.value = {}
        showTaskForm.value = true
    }
</script>

<template>
    <div>
        <button @click="newTask">New task</button>
    </div>

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

    <dialog ref="taskEditDialog">
        <TaskForm v-model="taskForEdit" v-if="showTaskForm" />
    </dialog>
</template>
