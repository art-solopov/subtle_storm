import {html, css, LitElement, classMap} from 'lit'

const openIcon = RAILS_ASSET_URL('/mingcute/hamburger_line.svg')
const closeIcon = RAILS_ASSET_URL('/mingcute/close_fill.svg')

export class SiteSidebar extends LitElement {
    static styles = css`
    :host {
        --padding: 0.25rem;
        --_button-size: var(--button-size, 2rem);
        --_button-offset: var(--button-offset, 2px);
        flex-basis: calc(var(--_button-size) + var(--_button-offset));
    }

    aside {
        position: fixed;
        left: 0;
        top: 0;

        height: 100%;
        width: min(15em, 30%);
        background: var(--background);
        color: var(--color);
        box-shadow: calc(var(--_button-size) / 2 + var(--_button-offset)) 0 var(--background);

        transform: translateX(-100%);
        transition: transform 0.2s ease;

        box-sizing: border-box;
        padding-block: var(--padding);

        isolation: isolate;
        z-index: 99;

        &.open {
            transform: none;
        }
    }

    .padding {
        padding-inline: var(--padding);
    }

    .toggle-button-container {
        background-color: var(--pico-muted-border-color);
        border: 3px solid var(--pico-muted-color);
        border-radius: 1000px;
        corner-shape: squircle;
        position: absolute;
        left: calc(100% + var(--_button-offset));

        /* Mostly to fix the oversized hamburger */
        scale: 60%;
        transform-origin: 0 50%;
    }

    .bg {
        transition: opacity 0.2s ease;
        transition-behavior: allow-discrete;
        background: black;
        opacity: 0.6;

        position: fixed;
        inset: 0;

        @starting-style {
            opacity: 0;
        }
    }
    `

    static properties = {
        open: {type: Boolean}
    }

    constructor() {
        super()
        this.open = false
    }

    render() {
        const classes = {
            open: this.open
        }

        return html`
        <aside class="${classMap(classes)}">
            <div class="toggle-button-container">
                <slot name="toggle-button" @click="${this._toggleOpen}"></slot>
            </div>
            <div class="padding">
                <slot></slot>
            </div>
        </aside>
        ${this._bg()}
        `
    }

    _bg() {
        if(!this.open) return null

        return html`<div class="bg" @click="${this._toggleOpen}"></div>`
    }

    _toggleOpen(event) {
        // let button = event.target.closest('button')
        let nodes = this.shadowRoot.querySelector('slot[name="toggle-button"]').assignedNodes()
        let button = nodes.find(e => e.nodeName == 'BUTTON')
        this.open = !this.open

        button.classList.toggle('is-active', this.open)
        button.setAttribute('aria-pressed', this.open.toString())
    }
}
