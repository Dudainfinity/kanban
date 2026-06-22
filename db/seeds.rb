# Quadro de demonstração com colunas e cartões.
Card.delete_all
Column.delete_all
Board.delete_all

board = Board.create!(name: "Sprint do Produto")

todo  = board.columns.create!(name: "A Fazer", position: 1)
doing = board.columns.create!(name: "Em Progresso", position: 2)
done  = board.columns.create!(name: "Concluído", position: 3)

todo.cards.create!([
  { title: "Desenhar tela de login", description: "Wireframe + protótipo no Figma", position: 1 },
  { title: "Configurar pipeline de CI", description: "GitHub Actions rodando os testes", position: 2 },
  { title: "Escrever testes de modelo", position: 3 }
])

doing.cards.create!([
  { title: "Integrar gateway de pagamento", description: "Stripe em modo de teste", position: 1 },
  { title: "Endpoint de relatórios", position: 2 }
])

done.cards.create!([
  { title: "Setup do projeto Rails 8", position: 1 },
  { title: "Modelagem do banco", description: "Migrações e índices", position: 2 }
])

puts "Board '#{board.name}': #{board.columns.count} colunas, #{board.cards.count} cartões"
