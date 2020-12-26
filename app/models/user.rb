class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :recoverable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :created_questions, foreign_key: 'author_id', class_name: 'Question', dependent: :destroy
  has_many :created_answers, foreign_key: 'author_id', class_name: 'Answer', dependent: :destroy

  def author?(record)
    id == record.author_id
  end
end
