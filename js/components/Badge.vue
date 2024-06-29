<script setup>
    import { computed } from 'vue'

    const props = defineProps({
        area: String,
        category: String
    });

    const classes = computed(() => [props.area, `is-${props.category}`]);
</script>

<template>
    <span class="badge border none" :class="classes"><slot></slot></span>
</template>

<style scoped>
.badge {
    background-color: var(--_bgcolor);
    color: var(--_color);
    border-color: var(--_color);

    font-size: 1.2em;
}

.project {
    &.is-new {
        --_bgcolor: aliceblue;
        --_color: navy;
    }

    &.is-in_progress {
        --_bgcolor: navy;
        --_color: white;
    }

    &.is-done {
        --_bgcolor: darkgreen;
        --_color: white;
    }
}
</style>
