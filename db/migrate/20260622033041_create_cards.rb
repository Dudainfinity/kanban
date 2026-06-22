class CreateCards < ActiveRecord::Migration[8.1]
  def change
    create_table :cards do |t|
      t.references :column, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
