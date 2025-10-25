import { Controller } from '@hotwired/stimulus'

// TODO: unite with ProjectsSelectorController?
class FormProjectsSelectorController extends Controller {
    static values = {
        frame: String
    }

    connect() {
        console.log("Connected", this.element)
    }

    changeProject(event) {
        const loc = new URL(location)
        const selected = event.target.selectedOptions[0]
        const code = selected.dataset.code
        loc.searchParams.set('project', code)
        Turbo.visit(loc.toString(), {frame: this.frameValue})
    }
}

export default FormProjectsSelectorController
