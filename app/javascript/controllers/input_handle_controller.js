import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="input-handle"
export default class extends Controller {
    static targets = ["textarea", "submit"]

    input() {
        const textarea = this.textareaTarget;
        const submitBtn = this.submitTarget;
        console.log(textarea, submitBtn);
        if (!textarea || !submitBtn) return;

        const updateSubmitButtonState = () => {
            submitBtn.disabled = textarea.value.trim() === "";
        };

        textarea.addEventListener("input", updateSubmitButtonState);
        updateSubmitButtonState();
    }
}
