import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static values = {url: String, page: Number}
    static targets = ["loadMoreButton"]

    connect() {
        this.loading = false
    }

    loadMore(event) {
        if (this.loading) return

        event.preventDefault()
        this.loading = true

        const button = event.target
        const originalText = button.textContent
        button.textContent = "Loading..."
        button.disabled = true

        fetch(`${this.urlValue}?page=${this.pageValue}`, {
            method: "GET",
            headers: {
                "Accept": "text/vnd.turbo-stream.html",
                "X-Requested-With": "XMLHttpRequest"
            }
        })
            .then(response => response.text())
            .then(html => {
                Turbo.renderStreamMessage(html)
                this.pageValue++
                this.loading = false

                // Re-enable button if there are more replies
                setTimeout(() => {
                    const newButton = this.element.querySelector(
                        '[data-load-more-replies-target="loadMoreButton"]'
                    )
                    if (newButton) {
                        newButton.disabled = false
                    }
                }, 100)
            })
            .catch(error => {
                console.error("Error loading more replies:", error)
                this.loading = false
                button.textContent = originalText
                button.disabled = false
            })
    }
}
