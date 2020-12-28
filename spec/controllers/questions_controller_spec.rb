require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  before { sign_in_user(user) }

  describe 'POST#create' do
    context 'valid attributes' do
      it 'save a new question and redirects to show view' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'invalid attributes' do
      it 'does not save a new question and renders new template' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        expect(response).to render_template :new
      end
    end
  end
end
