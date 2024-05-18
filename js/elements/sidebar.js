import {LitElement, html, css} from 'lit';
import {classMap} from 'lit/directives/class-map.js';

export class Sidebar extends LitElement {
    static styles = css`
    :host {
        position: fixed;
        height: 100vh;
    }

    aside {
        display: grid;
        grid-template-columns: 0 0.5rem;
        transition: grid-template-columns 0.6s;

        .slot {
            overflow: hidden;
        }

        &.open {
            grid-template-columns: clamp(10rem, calc(50vw - var(--hiq-max-container-width) / 2 - 2rem), 40rem) 0.5rem;

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
                <button @click=${this._toggle}>+</button>
            </div>
        </aside>
        `
    }

    _toggle() {
        this.open = !this.open
    }
}
