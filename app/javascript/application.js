// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const dismissFlashMessages = () => {
	document.querySelectorAll('[data-flash-message]').forEach((element) => {
		if (element.dataset.fadeScheduled === "true") {
			return
		}

		element.dataset.fadeScheduled = "true"
		element.style.transition = "opacity 0.5s ease"

		window.setTimeout(() => {
			element.style.opacity = "0"

			window.setTimeout(() => {
				element.remove()
			}, 500)
		}, 5000)
	})
}

document.addEventListener("turbo:load", dismissFlashMessages)
