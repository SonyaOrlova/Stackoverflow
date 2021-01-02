require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  describe 'POST#create' do
    context 'authenticated user' do
      before { sign_in_user(user) }

      it 'creates a new question with valid attributes and see show view' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        expect(response).to redirect_to assigns(:question)
      end

      it 'does not create a new question with invalid attributes and see new template' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        expect(response).to render_template :new
      end
    end

    context 'not authenticated user' do
      it 'can not create a new question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'author' do
      before { sign_in_user(user) }

      it 'updates the question attributes' do
        new_title = 'New question title'
        new_body = 'New question body'

        patch :update, params: { id: question, question: { title: new_title, body: new_body } }, format: :js
        question.reload

        expect(question.title).to eq new_title
        expect(question.body).to eq new_body
      end

      it 'does not update the question attributes' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
    end

    context 'not author' do
      it 'can not update the question attributes' do
        new_title = 'New question title'
        new_body = 'New question body'

        patch :update, params: { id: question, question: { title: new_title, body: new_body } }, format: :js
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author' do
      before { sign_in_user(user) }

      it 'deletes the question and redirects to questions view' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author' do
      it 'can not delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end
    end
  end
end
