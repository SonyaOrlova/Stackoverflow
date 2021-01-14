require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe 'POST#create' do
    context 'authenticated user' do
      before { sign_in_user(user) }

      it 'creates a new answer with valid attributes' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'does not create a new answer with invalid attributes' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(question.answers, :count)
      end
    end

    context 'not authenticated user' do
      it 'can not create a new question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'author' do
      before { sign_in_user(user) }

      it 'updates the answer attributes' do
        new_body = 'New answer body'

        patch :update, params: { id: answer, answer: { body: new_body } }, format: :js
        answer.reload

        expect(answer.body).to eq new_body
      end

      it 'does not update the answer attributes' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        answer.reload

        expect(answer.body).to eq answer.body
      end
    end

    context 'not author' do
      it 'can not update the question attributes' do
        new_body = 'New answer body'

        patch :update, params: { id: answer, answer: { body: new_body } }, format: :js
        answer.reload

        expect(answer.body).to eq answer.body
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author' do
      before { sign_in_user(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'not author' do
      it 'can not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end
    end
  end
end
