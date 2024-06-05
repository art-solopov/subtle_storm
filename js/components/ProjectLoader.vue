<script setup>
    import { ref, computed, onMounted } from 'vue'

    import { index } from '../repo/projects'

    const projects = ref([])
    const currentProject = ref(undefined)
    
    const isShown = computed(() => !!currentProject.value);

    function updateProjectFromMain() {
        const { currentProject: project } = window.top_content.dataset
        currentProject.value = project
    }

    onMounted(async () => {
        projects.value = await index()

        window.top_content.addEventListener('htmx:afterSettle', updateProjectFromMain)
        updateProjectFromMain()
    })
</script>

<template>
    <select :class="{ 'is-hidden': !isShown }">
        <option v-for="project in projects" :value="project._key" :selected="project._key == currentProject">{{ project.name }}</option>
    </select>
</template>

<style scoped>
</style>
