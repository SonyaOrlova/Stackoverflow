class AnswersController < ApplicationController
  expose :question, -> { Question.find(params[:question_id]) if params[:question_id] }
  expose :answer, scope: -> { question&.answers || Answer }

  def create
    if answer.save
      redirect_to question, notice: 'Answer was successfuly created'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
