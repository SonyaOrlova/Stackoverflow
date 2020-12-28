class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :question, only: %i[show destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Question was successfuly created'
    else
      render :new
    end
  end

  def show
    @answer = @question.answers.new
  end

  def destroy
    @question.destroy

    redirect_to questions_path, notice: 'Question was successfully deleted'
  end

  private

  def question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
