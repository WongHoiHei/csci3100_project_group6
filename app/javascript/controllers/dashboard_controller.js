import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  // Added the chart targets here
  static targets = ["venueList", "equipmentList", "venueChart", "equipmentChart"]
  static values = { url: String }
  
  // Store chart instances so we can destroy them on update
  charts = {}
  rawData = { venues: [], equipments: [] }

  connect() {
    this.update()
  }

  async update() {
    const tid = this.element.querySelector('[name="tenant_id"]').value
    const response = await fetch(`${this.urlValue}.json?tenant_id=${tid}`)
    this.rawData = await response.json()
    this.applyFilters()
  }

  applyFilters() {
    const query = this.element.querySelector('[name="query"]').value.toLowerCase()
    const sortMode = this.element.querySelector('[name="sort"]').value

    const processList = (list) => {
      let filtered = list.filter(item => item.name.toLowerCase().includes(query))
      
      return filtered.sort((a, b) => {
        if (sortMode === "usage_desc") return b.usage_count - a.usage_count
        if (sortMode === "usage_asc") return a.usage_count - b.usage_count
        return a.name.localeCompare(b.name)
      })
    }

    const filteredVenues = processList(this.rawData.venues)
    const filteredEquipments = processList(this.rawData.equipments)

    // 1. Render the Tables (with Tailwind classes)
    this.renderRows(this.venueListTarget, filteredVenues)
    this.renderRows(this.equipmentListTarget, filteredEquipments)

    // 2. Render the Charts
    this.renderChart(this.venueChartTarget, "Venues", filteredVenues, "#3b82f6") // Blue
    this.renderChart(this.equipmentChartTarget, "Equipment", filteredEquipments, "#10b981") // Emerald
  }

  renderRows(target, items) {
    if (items.length === 0) {
      target.innerHTML = `<tr><td colspan="2" class="p-8 text-center text-slate-400">No results found</td></tr>`
      return
    }

    target.innerHTML = items.map(item => `
      <tr class="hover:bg-slate-50 transition-colors">
        <td class="p-4 font-medium text-slate-700">${item.name}</td>
        <td class="p-4 text-right">
          <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-blue-100 text-blue-800">
            ${item.usage_count}
          </span>
        </td>
      </tr>
    `).join('')
  }

  renderChart(canvasElement, label, items, color) {
    const chartId = canvasElement.dataset.dashboardTarget
    
    // Crucial: Destroy the old chart instance if it exists
    if (this.charts[chartId]) {
      this.charts[chartId].destroy()
    }

    this.charts[chartId] = new Chart(canvasElement, {
      type: 'bar',
      data: {
        labels: items.map(i => i.name),
        datasets: [{
          label: 'Total Usage',
          data: items.map(i => i.usage_count),
          backgroundColor: color,
          borderRadius: 6
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true, ticks: { precision: 0 } }
        }
      }
    })
  }
}