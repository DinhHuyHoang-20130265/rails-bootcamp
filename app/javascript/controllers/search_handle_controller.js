import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        url: String,
    }
    debounce = (callback, wait) => {
        let timeoutId = null;
        return (...args) => {
            window.clearTimeout(timeoutId);
            timeoutId = window.setTimeout(() => {
                callback(...args);
            }, wait);
        };
    };

    handleInput = this.debounce((e) => {
        const query = e.target.value;

        fetch(`${this.urlValue}?query=${query}`, {
            method: "GET",
            headers: {
                "Accept": "text/vnd.turbo-stream.html",
                "X-Requested-With": "XMLHttpRequest"
            }
        })
            .then(response => response.text())
            .then(html => {
                Turbo.renderStreamMessage(html)
            })
            .catch(error => {
                console.error("Error:", error);
            })
    }, 250);
}
