<script setup>
    import { ref } from 'vue'

    import navArrowRight from '../assets/nav-arrow-right.svg'

    const isOpen = ref(false)

    function toggle() {
        isOpen.value = !isOpen.value
    }
</script>

<template>
    <nav class="drawer" :class="{ open: isOpen }">
        <div class="slot">
            <slot></slot>
        </div>
        <!-- 
        <div class="button-container">
            <button @click=toggle title="Toggle" class="toggle-button">
                <img :src=navArrowRight>
            </button>
        </div>
        -->
    </nav>
</template>

<style scoped>

aside {
    position: fixed;
    height: 100vh;
    display: grid;

    --_container-width: 50rem; 
    --grid-size: clamp(10rem, calc(50vw - var(--_container-width) / 2 - 2rem), 20rem);
    grid-template-columns: var(--grid-size) 0.5rem;

    translate: calc(-1 * var(--grid-size));

    --transition-time: 0.6s;
    transition: translate var(--transition-time);

    background-color: var(--nav-color, white);
    color: var(--text-color, black);

    z-index: 1;

    .slot {
        overflow: hidden;

        display: flex;
        flex-flow: column;
        align-items: stretch;
    }

    .button-container {
        background: gray;
    }

    .toggle-button {
        width: 3rem;
        aspect-ratio: 1;
        border: 1px solid var(--nav-color, black);
        border-radius: 50%;
        font-size: 1.5rem;
        translate: -1rem;

        & img {
            height: 1em;
            transition: rotate var(--transition-time) linear;
        }
    }

    &.open {
        translate: 0;

        .toggle-button img {
            rotate: 180deg;
        }
    }
}
</style>
