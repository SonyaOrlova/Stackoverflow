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

  def delete_file
    @file = ActiveStorage::Attachment.find(params[:file])

    @file.purge if current_user.author?(@file.record)
  end

  private

  def answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :title, :url, :_destroy]).merge({ author_id: current_user.id })
  end
end
