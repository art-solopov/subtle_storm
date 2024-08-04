<script setup>
    import { ref, computed, onMounted } from 'vue'
    import { useStore } from '@nanostores/vue'

    import { $projects } from '../stores/projects'
    import { $currentProjectKey, setProject } from '../stores/current_project'

    const projects = useStore($projects)
    const currentProject = useStore($currentProjectKey)
    
    const isShown = computed(() => !!currentProject.value);

    function updateProject(event) {
        const project = event.target.value
        setProject(project)
    }
</script>

<template>
    <div class="field suffix round border" :class="{ 'is-hidden': !isShown }">
        <select name="project" @change="updateProject">
            <option v-for="project in projects" :value="project._key" :selected="project._key == currentProject" >{{ project.name }}</option>
        </select>
        <i>arrow_drop_down</i>
    </div>
</template>

<style scoped>
</style>
