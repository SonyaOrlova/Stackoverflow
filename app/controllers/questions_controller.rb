class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question, build: ->(question_params) { current_user&.created_questions&.new(question_params) || Question.new(question_params) }
  expose :questions, -> { Question.all }

  expose :answer, -> { question.answers.new }

  def index; end

  def create
    if question.save
      redirect_to question, notice: 'Question was successfuly created'
    else
      render :new
    end
  end

  def show; end

  def destroy
    question.destroy

    flash.now[:notice] = 'Question was successfully deleted'

    render :index
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
