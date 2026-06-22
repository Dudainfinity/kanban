class Card < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :column
  has_one :board, through: :column

  validates :title, presence: true

  before_create :set_position

  # --- Tempo real via Turbo Streams ---
  # Toda alteração é transmitida para quem estiver com o board aberto
  # (turbo_stream_from board), então os cartões aparecem/movem ao vivo entre
  # abas sem escrever JavaScript de WebSocket.
  after_create_commit  :broadcast_insert
  after_update_commit  :broadcast_move
  after_destroy_commit :broadcast_remove

  def broadcast_insert
    broadcast_append_to board, target: dom_id(column, :cards),
      partial: "cards/card", locals: { card: self }
  end

  # Em um update, o cartão pode ter trocado de coluna: removemos o elemento
  # de onde estava e o reinserimos na coluna atual.
  def broadcast_move
    broadcast_remove_to board
    broadcast_append_to board, target: dom_id(column, :cards),
      partial: "cards/card", locals: { card: self }
  end

  def broadcast_remove
    broadcast_remove_to board
  end

  private

  def set_position
    self.position ||= (column.cards.maximum(:position) || 0) + 1
  end
end
