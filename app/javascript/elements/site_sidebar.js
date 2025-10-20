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

    .toggle-button {
        display: inline-block;

        font-size: 1.5rem;
        height: var(--_button-size);
        width: var(--_button-size);
        padding: 0;
        text-align: center;
        vertical-align: middle;

        border-radius: 50%;
        box-sizing: border-box;

        position: absolute;
        left: calc(100% + var(--_button-offset));
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
            <button class="toggle-button" @click="${this._toggleOpen}">
                <img src="${this.open ? closeIcon : openIcon}">
            </button>
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

    _toggleOpen() {
        this.open = !this.open
    }
}
