class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :answer, only: %i[update destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
  end

  def update
    @question = @answer.question
    @answer.update(answer_params) if current_user.author?(@answer)
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author?(@answer)
  end

  private

  def answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge({ author_id: current_user.id })
  end
end
