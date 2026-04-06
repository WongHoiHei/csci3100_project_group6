import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from 'chart.js';

// Register Chart.js components
Chart.register(...registerables);

export default class extends Controller {
  // These targets correspond to 'data-dashboard-target' in your HAML
  static targets = ["canvas", "usageRate"]
  
  // This value corresponds to 'data-dashboard-url-value' in your HAML
  static values = { url: String }

  connect() {
    // This runs as soon as the element appears on the page
    this.loadData()
  }

  // The main data-fetching logic
  async loadData() {
    try {
      const response = await fetch(this.urlValue)
      if (!response.ok) throw new Error("Network response was not ok")
      
      const data = await response.json()
      
      // 1. Update the UI Text
      this.updateUsageRate(data.usage_rate)
      
      // 2. Render the Graph
      this.renderChart(data.bookings_data)
    } catch (error) {
      console.error("Dashboard Load Error:", error)
      this.usageRateTarget.textContent = "Error loading data"
    }
  }

  // Helper to update the percentage text
  updateUsageRate(rate) {
    this.usageRateTarget.textContent = `${rate}%`
  }

  // Logic to build/re-build the chart
  renderChart(bookingsData) {
    // If a chart already exists (e.g. from a previous refresh), destroy it
    // to prevent memory leaks and "hover flickering"
    if (this.chart) {
      this.chart.destroy()
    }

    const labels = Object.keys(bookingsData)
    const values = Object.values(bookingsData)

    this.chart = new Chart(this.canvasTarget, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: 'Bookings per Day',
          data: values,
          borderColor: '#2563eb', // Blue-600
          backgroundColor: 'rgba(37, 99, 235, 0.1)',
          fill: true,
          tension: 0.4, // Smoothing the line
          pointRadius: 4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: { stepSize: 1 }
          }
        }
      }
    })
  }

  // This can be triggered by a "Refresh" button in HAML: 
  // data-action="click->dashboard#refresh"
  refresh(event) {
    event.preventDefault()
    this.loadData()
  }
}