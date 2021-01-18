class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { joins(:question).order(Arel.sql('CASE WHEN answers.id = questions.best_answer_id THEN 1 ELSE 0 END DESC')) }

  def best?
    id == question.best_answer_id
  end
end
