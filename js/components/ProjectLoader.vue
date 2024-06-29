<script setup>
    import { ref, computed, onMounted } from 'vue'
    import { useStore } from '@nanostores/vue'

    import { $projects } from '../stores/projects'
    import { $currentProjectKey } from '../stores/current_project'

    const projects = useStore($projects)
    const currentProject = useStore($currentProjectKey)
    
    const isShown = computed(() => !!currentProject.value);
</script>

<template>
    <div class="field suffix round border" :class="{ 'is-hidden': !isShown }">
        <select name="project"
            hx-get="/tasks" hx-trigger="change" hx-push-url="true"
            hx-target="#top_content" hx-select="#top_content" hx-swap="outerHTML">
            <option v-for="project in projects" :value="project._key" :selected="project._key == currentProject" >{{ project.name }}</option>
        </select>
        <i>arrow_drop_down</i>
    </div>
</template>

<style scoped>
</style>
