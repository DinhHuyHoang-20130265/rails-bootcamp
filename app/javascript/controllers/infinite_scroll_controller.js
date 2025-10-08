import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static values = {url: String, page: Number}

  connect() {
    this.loading = false
    this.observer = new IntersectionObserver(this.handleIntersection.bind(this), {
      root: null,
      rootMargin: "100px",
      threshold: 0.1
    })

    this.setupInfiniteScroll()

    // Also add scroll event listener as fallback
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener('scroll', this.handleScroll)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
    window.removeEventListener('scroll', this.handleScroll)
  }

  setupInfiniteScroll() {
    // Try to observe the loading indicator first
    const loadingIndicator = document.getElementById("loading-indicator")
    if (loadingIndicator) {
      this.observer.observe(loadingIndicator)
    }
    else {
      // If no loading indicator exists, there are no more tweets to load
      // Disconnect the observer to prevent unnecessary API calls
      this.observer.disconnect()
    }
  }

  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting && !this.loading && this.hasMoreTweets()) {
        this.loadMore()
      }
    })
  }

  handleScroll() {
    if (this.loading || !this.hasMoreTweets()) return

    const loadingIndicator = document.getElementById("loading-indicator")
    if (!loadingIndicator) return

    const rect = loadingIndicator.getBoundingClientRect()
    const isVisible = rect.top < window.innerHeight && rect.bottom > 0

    if (isVisible) {
      this.loadMore()
    }
  }

  hasMoreTweets() {
    // Check if the loading indicator exists - if it doesn't, there are no more tweets
    const loadingIndicator = document.getElementById("loading-indicator")
    return loadingIndicator !== null
  }

  loadMore() {
    if (this.loading || !this.hasMoreTweets()) return

    this.loading = true
    const loadingIndicator = document.getElementById("loading-indicator")
    if (loadingIndicator) {
      loadingIndicator.style.height = "auto"
      loadingIndicator.style.overflow = "visible"
    }

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

        // Check if loading indicator still exists after the response
        const currentLoadingIndicator = document.getElementById("loading-indicator")
        if (currentLoadingIndicator) {
          currentLoadingIndicator.style.height = "1px"
          currentLoadingIndicator.style.overflow = "hidden"
        }

        // Re-setup the infinite scroll observer
        setTimeout(() => {
          this.setupInfiniteScroll()
        }, 500)
      })
      .catch(error => {
        console.error("Error loading more tweets:", error)
        this.loading = false
        const currentLoadingIndicator = document.getElementById("loading-indicator")
        if (currentLoadingIndicator) {
          currentLoadingIndicator.style.height = "1px"
          currentLoadingIndicator.style.overflow = "hidden"
        }
      })
  }
}
