class CardsController < ApplicationController
  before_action :set_card, only: %i[update destroy]

  def create
    @card = Card.new(create_params)
    if @card.save
      # O broadcast do model já atualiza todas as abas; respondemos vazio
      # para a aba que enviou o formulário (Turbo trata o redirect/no-content).
      head :created
    else
      render json: { errors: @card.errors.full_messages }, status: :unprocessable_content
    end
  end

  # Movimentação do cartão (drag-and-drop): troca de coluna e/ou posição.
  def update
    @card.update!(move_params)
    head :ok
  end

  def destroy
    @card.destroy!
    head :no_content
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def create_params
    params.require(:card).permit(:title, :description, :column_id)
  end

  def move_params
    params.require(:card).permit(:column_id, :position)
  end
end
