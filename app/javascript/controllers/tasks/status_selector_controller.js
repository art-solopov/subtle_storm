import { Controller } from "@hotwired/stimulus"

class StatusSelectorController extends Controller {
    static targets = ['form', 'statusField']

    changeStatus(event) {
        let statusId = event.currentTarget.dataset.statusId
        this.statusFieldTarget.value = statusId
        this.formTarget.requestSubmit()
    }

    finalize() {
        this.element.open = false
    }
}

export default StatusSelectorController
