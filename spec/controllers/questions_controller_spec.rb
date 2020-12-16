require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST#create' do
    context 'с валидными параметрами' do
      it 'добавляет новый вопрос в базу данных и возвращает на страницу созданного вопроса' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'с невалидными параметрами' do
      it 'не добавляет новый вопрос в базу данных и возвращает на страницу создания нового вопроса' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        expect(response).to render_template :new
      end
    end
  end
end
