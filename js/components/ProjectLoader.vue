<script setup>
    import { ref, computed, onMounted } from 'vue'
    import { useStore } from '@nanostores/vue'

    import { $projects } from '../stores/projects'
    import { $currentProject } from '../stores/current_project'

    const projects = useStore($projects)
    const currentProject = useStore($currentProject)
    
    const isShown = computed(() => !!currentProject.value);
</script>

<template>
    <select :class="{ 'is-hidden': !isShown }" name="project"
        hx-get="/tasks" hx-trigger="change" hx-push-url="true"
        hx-target="#top_content" hx-select="#top_content" hx-swap="outerHTML">
        <option v-for="project in projects" :value="project._key" :selected="project._key == currentProject" >{{ project.name }}</option>
    </select>
</template>

<style scoped>
</style>
