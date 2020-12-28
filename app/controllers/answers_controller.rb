class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    @question = @question = Question.find(params[:question_id])

    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Answer was successfuly created'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    @answer.destroy

    redirect_to @answer.question, notice: 'Answer was successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
