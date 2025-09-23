function initializeTweetForm() {
    const textarea = document.getElementById("floatingTextarea");
    const submitBtn = document.getElementById("tweet-submit");
    if (!textarea || !submitBtn) return;

    const updateSubmitButtonState = () => {
        submitBtn.disabled = textarea.value.trim() === "";
    };

    textarea.addEventListener("input", updateSubmitButtonState);
    updateSubmitButtonState(); // Initial check
}

["turbo:load", "turbo:frame-load", "turbo:render"].forEach(eventName => {
    document.addEventListener(eventName, initializeTweetForm);
});
