import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
    static targets = ['template', 'container', 'subform']
    static values = {
        fieldName: String,
        fieldTemplate: String,
        indexTemplate: String,
        count: Number
    }

    connect() {
        this.extraFieldsCount = 0
    }

    addForm() {
        this.countValue++;
        this.extraFieldsCount++;
        const content = document.importNode(this.templateTarget.content, true)
        for (let element of content.querySelectorAll('label, input, select, textarea')) {
            this._replaceAttr(element, 'name')
            this._replaceAttr(element, 'id')
            this._replaceAttr(element, 'for')
        }

        let idInput = content.querySelector('input[name$="[id]"]')
        if (idInput) {
            idInput.value = `_${this.extraFieldsCount}`
        }

        this._subformsContainer.insertAdjacentElement('beforeend', content.children[0])
    }

    toggleSubform(event) {
        // TODO: maybe extract into a separate controller
        let target = event.currentTarget
        let subform = this._findSubform(target)
        let disabled = subform.toggleAttribute('data-disabled')
        for (let input of subform.querySelectorAll('input:not([type="hidden"]), select, textarea')) {
            input.toggleAttribute('disabled', disabled)
        }
        let destroyInput = subform.querySelector('input[name$="[_destroy]"]')
        if(destroyInput) { destroyInput.value = disabled ? 'true' : '' }
        if(target.tagName == 'BUTTON') {
            target.setAttribute('aria-pressed', disabled ? 'true' : 'false')
        }
    }

    deleteSubform(event) {
        let subform = this._findSubform(event.currentTarget)
        subform.remove()
    }

    get _subformsContainer() {
        if(this.hasContainerTarget) { return this.containerTarget }

        return this.element
    }

    _findSubform(element) {
        for (let subform of this.subformTargets) {
            if(subform.contains(element)) { return subform }
        }
    }

    _replaceAttr(element, attr) {
        let value = element.getAttribute(attr)
        if(value == null) return;

        value = value.replace(this.fieldTemplateValue, this.fieldNameValue).replace(this.indexTemplateValue, this.countValue)
        element.setAttribute(attr, value)
    }

}
