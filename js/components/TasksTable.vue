<script setup>
    import { ref, watch, computed } from 'vue'
    import { useStore } from '@nanostores/vue'

    import { $currentProject } from '../stores/current_project'
    import { index } from '../repo/tasks'
    import TaskForm from './TaskForm.vue'
    import Badge from './Badge.vue'

    const currentProject = useStore($currentProject)
    const tasks = ref([])
    const taskForEdit = ref(null)
    const taskEditDialog = ref()
    const showTaskForm = ref(false)

    const statusMap = computed(() => {
        let m = new Map()
        if(currentProject.value) {
            for (let st of currentProject.value.statuses) {
                m.set(st.name, st)
            }
        }
        
        return m
    })

    async function reloadTasks(project) {
        if(project) { tasks.value = await index(project._key) }
        else { tasks.value = [] }
    }

    watch(currentProject, async project => reloadTasks(project), { immediate: true })

    watch(showTaskForm, (stf) => { 
        if(stf) { taskEditDialog.value.showModal() }
        else { taskEditDialog.value.close() }
    })

    function taskStatus(task) {
        return statusMap.value.get(task.status)
    }

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
            <tr v-for="task in tasks" :key="task._key">
                <td>
                    <Badge area="project" :category="taskStatus(task).category">
                        {{ task.status }}
                    </Badge>
                </td>
                <td>{{ formatTaskNumber(task) }}</td>
                <td>{{ task.title }}</td>
            </tr>
        </tbody>
    </table>

    <dialog ref="taskEditDialog">
        <TaskForm v-model="taskForEdit" v-if="taskForEdit" />
    </dialog>
</template>
