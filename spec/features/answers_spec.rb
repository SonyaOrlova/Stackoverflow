require 'rails_helper'

feature 'Authenticated user can answer to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in_user(user)

      visit question_path(question)
    end

    scenario 'answers the question successfuly' do
      body = 'Answer body'

      fill_in 'answer_body', with: body

      click_on 'Reply'

      expect(find('.list')).to have_content body
    end

    scenario 'answers the question with failure' do
      click_on 'Reply'

      expect(page).to have_content 'Body can\'t be blank'
    end

    scenario 'deletes the answer' do
      answer = create(:answer, question: question, author: user)

      visit current_path

      expect(page).to have_content answer.body

      click_on 'Delete'

      expect(page).to have_content 'Answer was successfully deleted'
      expect(page).not_to have_content answer.body
    end
  end

  scenario 'Unauthenticated user can not answer the question' do
    visit question_path(question)

    expect(page).to_not have_content 'Reply'
  end
end
