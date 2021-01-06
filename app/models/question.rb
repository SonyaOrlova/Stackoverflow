class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true
end
