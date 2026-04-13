import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions"]
  static values = { type: String } 

  search() {
    const query = this.inputTarget.value.toLowerCase().trim()
    if (query.length < 1) { this.hide(); return; }

    fetch('/dashboards.json')
      .then(response => response.json())
      .then(data => {
        let pool = (this.typeValue === "venue") ? data.venues : 
                   (this.typeValue === "equipment") ? data.equipments : 
                   [...data.venues, ...data.equipments];

        const matches = pool.filter(item => 
          item.name.toLowerCase().includes(query)
        ).slice(0, 5)

        this.render(matches)
      })
  }

  render(matches) {
    if (matches.length === 0) { this.hide(); return; }

    this.suggestionsTarget.innerHTML = matches.map(match => `
      <div class="suggestion-item"
           style="padding: 12px 15px; cursor: pointer; border-bottom: 1px solid #eee; 
                  background-color: #ffffff; color: #14532d; font-weight: 600; opacity: 1 !important;"
           data-action="click->autocomplete#select"
           data-name="${match.name}">
        ${match.name}
      </div>
    `).join('')

    this.suggestionsTarget.style.display = "block";
    this.suggestionsTarget.classList.remove('hidden');
  }

  select(event) {
    const name = event.currentTarget.dataset.name;
    this.inputTarget.value = name;
    this.hide();
    
    const btn = this.element.querySelector('#search-btn') || 
                this.element.querySelector('input[type="submit"]');
    if (btn) btn.click();
  }

  hide() {
    this.suggestionsTarget.style.display = "none";
    this.suggestionsTarget.classList.add('hidden');
  }
}