class Board < ApplicationRecord
  has_many :columns, -> { order(:position) }, dependent: :destroy
  has_many :cards, through: :columns

  validates :name, presence: true
end
