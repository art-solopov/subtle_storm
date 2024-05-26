import {LitElement, html, css} from 'lit';
import {classMap} from 'lit/directives/class-map.js';

import navArrowRight from './icons/nav-arrow-right.svg'

export class Sidebar extends LitElement {
    static styles = css`
    :host {
        position: fixed;
        height: 100vh;
    }

    aside {
        height: 100%;
        display: grid;

        --grid-size: clamp(10rem, calc(50vw - var(--hiq-max-container-width) / 2 - 2rem), 20rem);
        grid-template-columns: var(--grid-size) 0.5rem;

        translate: calc(-1 * var(--grid-size));

        --transition-time: 0.6s;
        transition: translate var(--transition-time);

        background-color: var(--nav-color, white);
        color: var(--text-color, black);

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

            .slot {
            }
        }
    }
    `

    static properties = {
        open: {
            type: Boolean,
            default: false
        }
    }

    render() {
        let asideClasses = { open: this.open }

        return html`
        <aside class=${classMap(asideClasses)}>
            <div class="slot"><slot></slot></div>
            <div class="button-container">
                <button @click=${this._toggle} title="Toggle" class="toggle-button">
                    <img src=${navArrowRight}>
                </button>
            </div>
        </aside>
        `
    }

    _toggle() {
        this.open = !this.open
    }
}
