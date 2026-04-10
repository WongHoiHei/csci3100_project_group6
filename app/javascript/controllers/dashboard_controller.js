import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["venueList", "equipmentList", "venueChart", "equipmentChart"]
  static values = { url: String }
  
  charts = {}
  rawData = { venues: [], equipments: [] }

  connect() {
    // 1. Inject Tailwind as soon as we arrive
    this.injectTailwind()
    this.update()
  }

  disconnect() {
    this.removeTailwind()
    // Destroy charts to prevent memory bloat
    Object.values(this.charts).forEach(chart => chart.destroy())
  }

  injectTailwind() {
    if (document.getElementById("tailwind-cdn")) return

    const script = document.createElement("script")
    script.id = "tailwind-cdn"
    script.src = "https://cdn.tailwindcss.com"
    document.head.appendChild(script)
  }

  removeTailwind() {
    const script = document.getElementById("tailwind-cdn")
    if (script) script.remove()

    // Find and remove the style blocks Tailwind creates
    document.querySelectorAll('style').forEach(style => {
      // Tailwind CDN usually leaves markers like --tw- or identifies as 'tailwind'
      if (style.textContent.includes('--tw-') || style.textContent.includes('tailwind')) {
        style.remove()
      }
    })

    // Delete the tailwind object from the window
    if (window.tailwind) delete window.tailwind
  }

async update() {
    const tenantSelect = this.element.querySelector('[name="tenant_id"]')
    if (!tenantSelect) return

    const tid = tenantSelect.value
    // Fetch fresh data for the new tenant
    const response = await fetch(`${this.urlValue}.json?tenant_id=${tid}`)
    this.rawData = await response.json()
    
    // Once data is fetched, apply whatever filters (search/sort) are currently set
    this.applyFilters()
  }

  applyFilters() {
    const queryInput = this.element.querySelector('[name="query"]')
    const sortInput = this.element.querySelector('[name="sort"]')
    
    const query = queryInput ? queryInput.value.toLowerCase() : ""
    const sortMode = sortInput ? sortInput.value : "usage_desc"

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

    this.renderRows(this.venueListTarget, filteredVenues)
    this.renderRows(this.equipmentListTarget, filteredEquipments)

    this.renderChart(this.venueChartTarget, "Venues", filteredVenues, "#3b82f6")
    this.renderChart(this.equipmentChartTarget, "Equipment", filteredEquipments, "#10b981")
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
    if (this.charts[chartId]) this.charts[chartId].destroy()

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
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, ticks: { precision: 0 } } }
      }
    })
  }
}