<script setup>
    import { computed } from 'vue'

    const props = defineProps({
        area: String,
        category: String
    });

    const classes = computed(() => [props.area, `is-${props.category}`]);
</script>

<template>
    <span class="Badge" :class="classes"><slot></slot></span>
</template>

<style scoped>
.Badge {
    --_border-color: var(--hiq-color-gray-2);

    font-size: 85%;
    padding: 0.25em 0.5em;
    border: 1px solid var(--_border-color);
    border-radius: 0.5em;
}
</style>
