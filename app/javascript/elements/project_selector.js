import {html, css, LitElement} from 'lit'

export class ProjectsSelector extends LitElement {
    static style=css`
    slot {
        display: none;
    }
    `

    static properties = {
        frame: {type: String},
        _options: {type: Array, state: true}
    }

    render() {
        return html`
            <slot @slotchange=${this._handleUpdatedElements} style="display: none"></slot>
            <select @change=${this._handleSelect}>
                ${(this._options || []).map(option => this._renderOption(option))}
            </select>
        `
    }

    _handleUpdatedElements(e) {
        const childNodes = e.target.assignedElements({flatten: true})
        this._options = childNodes.map(e => {
            return {name: e.innerText, href: e.getAttribute('href'), selected: !!e.getAttribute('selected')}
        })
    }

    _renderOption(option) {
        const {name, href, selected} = option
        return html`<option value="${href}" ?selected="${selected}">${name}</option>`
    }

    _handleSelect(e) {
        const href = e.target.value
        Turbo.visit(href, {action: 'advance', frame: this.frame})
    }
}
