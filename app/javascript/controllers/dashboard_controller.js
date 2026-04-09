import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["venueList", "equipmentList"]
  static values = { url: String }
  
  // Store the data so we can re-sort it without hitting the server again
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
      // 1. Filter
      let filtered = list.filter(item => item.name.toLowerCase().includes(query))
      
      // 2. Sort
      return filtered.sort((a, b) => {
        if (sortMode === "usage_desc") return b.usage_count - a.usage_count
        if (sortMode === "usage_asc") return a.usage_count - b.usage_count
        return a.name.localeCompare(b.name) // name_asc default
      })
    }

    this.renderRows(this.venueListTarget, processList(this.rawData.venues))
    this.renderRows(this.equipmentListTarget, processList(this.rawData.equipments))
  }

  renderRows(target, items) {
    target.innerHTML = items.map(item => `
      <tr class="border-b last:border-0">
        <td class="py-3 font-medium">${item.name}</td>
        <td class="py-3 text-right font-bold text-gray-700">${item.usage_count}</td>
      </tr>
    `).join('')
  }
}