<script setup>
    import { ref, onMounted } from 'vue'

    import { index } from '../repo/projects'

    const projects = ref([])

    onMounted(async () => {
        projects.value = await index()
    })
</script>

<template>
    <select>
        <option v-for="project in projects" :value="project._key">{{ project.name }}</option>
    </select>
</template>
