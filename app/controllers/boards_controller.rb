class BoardsController < ApplicationController
  def index
    @boards = Board.all
    # Atalho de demo: se houver um único board, abre direto.
    redirect_to(@boards.first) if @boards.one?
  end

  def show
    @board = Board.includes(columns: :cards).find(params[:id])
  end
end
