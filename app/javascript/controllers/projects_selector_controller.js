import { Controller } from '@hotwired/stimulus'

class ProjectsSelectorController extends Controller {
    static values = {
        frame: String
    }

    changeProject(event) {
        const href = event.target.value
        Turbo.visit(href, {action: 'advance', frame: this.frameValue})
    }
}

export default ProjectsSelectorController
