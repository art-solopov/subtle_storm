<script setup>
    import { ref } from 'vue'
    import { useStore } from '@nanostores/vue'

    import { $currentProject } from '../stores/current_project'

    const currentProject = useStore($currentProject)

    const model = defineModel()
</script>

<template>
    <form>
        <fieldset>
            <p>
                <label for="input_title">Title</label>
                <input type="text" name="title" id="input_title" v-model="model.title">
            </p>

            <p>
                <label for="input_description">Description</label>
                <textarea id="input_description" name="description" v-model="model.description"></textarea>
            </p>
        </fieldset>
    </form>
</template>
