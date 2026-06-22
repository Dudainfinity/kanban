import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Habilita arrastar-e-soltar cartões entre colunas.
// Ao soltar, envia um PATCH para o servidor com a nova coluna e posição;
// o servidor persiste e dispara o Turbo Stream que atualiza as outras abas.
export default class extends Controller {
  static values = { columnId: Number }

  connect() {
    this.sortable = Sortable.create(this.element, {
      group: "cards",
      animation: 150,
      ghostClass: "card-ghost",
      onEnd: (event) => this.onEnd(event),
    })
  }

  disconnect() {
    this.sortable?.destroy()
  }

  onEnd(event) {
    const cardId = event.item.dataset.cardId
    const newColumnId = event.to.dataset.columnId
    const position = event.newIndex + 1

    fetch(`/cards/${cardId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ card: { column_id: newColumnId, position } }),
    })
  }
}
