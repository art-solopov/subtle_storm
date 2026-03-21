import { Controller } from '@hotwired/stimulus'

// TODO: unite with ProjectsSelectorController?
class FormProjectsSelectorController extends Controller {
    static targets = ['frame']

    changeProject(event) {
        const loc = new URL(location)
        const selected = event.target.selectedOptions[0]
        const code = selected.dataset.code
        loc.searchParams.set('project', code)
        Turbo.visit(loc.toString(), {frame: this.frameTarget})
    }
}

export default FormProjectsSelectorController
