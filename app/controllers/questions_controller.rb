class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :question, only: %i[show update destroy]

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

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    @question.destroy

    redirect_to questions_path, notice: 'Question was successfully deleted'
  end

  def set_best_answer
    answer = Answer.find(params[:answer])
    @question = answer.question

    @question.update({ best_answer_id: answer.id }) if current_user.author?(@question)
  end

  def delete_file
    @file = ActiveStorage::Attachment.find(params[:file])

    @file.purge if current_user.author?(@file.record)
  end

  private

  def question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :title, :url, :_destroy])
  end
end
