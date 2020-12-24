class QuestionsController < ApplicationController
  expose :question
  expose :questions, -> { Question.all }

  expose :answer, -> { question.answers.new }

  def create
    if question.save
      redirect_to question, notice: 'Question was successfuly created'
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
