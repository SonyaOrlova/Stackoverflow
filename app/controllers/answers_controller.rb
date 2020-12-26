class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) if params[:question_id] }
  expose :answer, build: ->(answer_params) { question&.answers&.new(answer_params) || Answer.new(answer_params) }

  def create
    answer.author = current_user

    if answer.save
      redirect_to question, notice: 'Answer was successfuly created'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy

    redirect_to answer.question, notice: 'Answer was successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
