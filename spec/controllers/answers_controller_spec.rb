require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST#create' do
    context 'с валидными параметрами' do
      it 'добавляет новый ответ в базу данных и возвращает на страницу созданного ответа' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
        expect(response).to redirect_to assigns(:exposed_answer)
      end
    end

    context 'с невалидными параметрами' do
      it 'не добавляет новый ответ в базу данных и возвращает на страницу создания нового ответа' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
        expect(response).to render_template :new
      end
    end
  end
end
