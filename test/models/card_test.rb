require "test_helper"

class CardTest < ActiveSupport::TestCase
  setup do
    @board = Board.create!(name: "B")
    @todo = @board.columns.create!(name: "A Fazer", position: 1)
    @done = @board.columns.create!(name: "Concluído", position: 2)
  end

  test "exige título" do
    assert_not @todo.cards.new(title: "").valid?
  end

  test "posição é atribuída automaticamente em sequência" do
    a = @todo.cards.create!(title: "A")
    b = @todo.cards.create!(title: "B")
    assert_equal 1, a.position
    assert_equal 2, b.position
  end

  test "criar cartão transmite um append via Turbo Stream para o board" do
    assert_turbo_stream_broadcasts [ @board ], count: 1 do
      @todo.cards.create!(title: "Novo")
    end
  end

  test "mover cartão de coluna transmite (remove + append)" do
    card = @todo.cards.create!(title: "Mover")
    assert_turbo_stream_broadcasts [ @board ], count: 2 do
      card.update!(column: @done)
    end
  end

  test "board acessa cartões através das colunas" do
    @todo.cards.create!(title: "X")
    @done.cards.create!(title: "Y")
    assert_equal 2, @board.cards.count
  end
end
