import {html, css, LitElement, classMap} from 'lit'

const openIcon = RAILS_ASSET_URL('/mingcute/hamburger_line.svg')
const closeIcon = RAILS_ASSET_URL('/mingcute/close_fill.svg')

export class SiteSidebar extends LitElement {
    static styles = css`
    :host {
        --padding: 0.25rem;
        flex-basis: 2rem;
    }

    aside {
        position: fixed;
        left: 0;
        top: 0;

        height: 100%;
        width: min(15em, 30%);
        background: var(--background);

        transform: translateX(-100%);
        transition: transform 0.2s ease;

        border-right: 2px solid gray;
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
        height: 2rem;
        width: 2rem;
        padding: 0;
        text-align: center;
        vertical-align: middle;

        border-radius: 50%;
        box-sizing: border-box;

        position: absolute;
        left: calc(100% + 2px);
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

        return html`<aside class="${classMap(classes)}">
            <button class="toggle-button" @click="${this._toggleOpen}">
                <img src="${this.open ? closeIcon : openIcon}">
            </button>
            <div class="padding">
                <slot></slot>
            </div>
            </aside>`
    }

    _toggleOpen() {
        this.open = !this.open
    }
}
