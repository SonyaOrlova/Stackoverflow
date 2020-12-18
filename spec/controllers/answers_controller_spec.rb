require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST#create' do
    context 'valid attributes' do
      it 'save a new answer and redirects to show view' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
        expect(response).to redirect_to assigns(:exposed_answer)
      end
    end

    context 'invalid attributes' do
      it 'does not save a new answer and renders new template' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
        expect(response).to render_template :new
      end
    end
  end
end
