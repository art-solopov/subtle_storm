import { Controller } from '@hotwired/stimulus'

// TODO: unite with ProjectsSelectorController?
class DependentFramesSelectorController extends Controller {
    static values = {'param': String}

    static targets = ['frame']

    refresh(event) {
        const loc = new URL(location)
        const selected = event.target.selectedOptions[0]
        const value = selected.dataset.code || selected.value
        loc.searchParams.set(this.paramValue, value)
        Turbo.visit(loc.toString(), {frame: this.frameTarget})
    }
}

export default DependentFramesSelectorController
