require 'rails_helper'

feature 'Authenticated user can answer the question', js: true do
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
      expect(page).to have_content 'Answer was successfully created'
    end

    scenario 'answers the question with failure' do
      click_on 'Reply'

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'can not answer the question' do
      expect(page).to_not have_content 'Reply'
    end
  end
end

feature 'Authenticated user can update the answer', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in_user(user)

      visit question_path(question)
    end

    scenario 'updates the answer successfuly' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Edit'
        click_on 'Edit'

        expect(page).to have_selector '.form_type_inline'
        expect(page).to have_content 'Cancel'

        new_body = 'New answer body'

        fill_in 'answer_body', with: new_body
        click_on 'Save'

        expect(page).to have_content new_body
        expect(page).not_to have_selector '.form_type_inline'
      end

      expect(page).to have_content 'Answer was successfully updated'
    end

    scenario 'updates the answer with failure' do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Edit'
        click_on 'Edit'

        fill_in 'answer_body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'can not update the answer' do
      expect(page).to_not have_content 'Edit'
    end
  end
end

feature 'Authenticated user can delete the answer', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in_user(user)

      visit question_path(question)
    end

    scenario 'deletes the answer' do
      visit current_path

      expect(page).to have_content answer.body

      within "#answer-#{answer.id}" do
        expect(page).to have_content answer.body
        click_on 'Delete'
      end

      expect(page).not_to have_content answer.body
      expect(page).to have_content 'Answer was successfully deleted'
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'can not delete the answer' do
      expect(page).to_not have_content 'Delete'
    end
  end
end
