import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    lat: { type: Number, default: 25.033 },
    lng: { type: Number, default: 121.565 },
  }

  connect() {
    if (window.google?.maps) {
      this.initMap()
    } else {
      this.loadGoogleMaps()
    }
  }

  loadGoogleMaps() {
    const script = document.createElement("script")
    script.src = `https://maps.googleapis.com/maps/api/js?key=${window.GOOGLE_MAPS_API_KEY}&callback=initGoogleMap&loading=async`
    script.defer = true
    window.initGoogleMap = () => this.initMap()
    document.head.appendChild(script)
  }

  initMap() {
    const position = { lat: this.latValue, lng: this.lngValue }

    const map = new google.maps.Map(this.element, {
      center: position,
      zoom: 14,
    })

    new google.maps.Marker({
      position,
      map,
      title: "Location"
    })
  }

  disconnect() {
    delete window.initGoogleMap
  }
}