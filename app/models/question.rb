class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User'
  has_many :links, as: :linkable, dependent: :destroy
  has_many_attached :files

  validates :title, :body, presence: true
end
