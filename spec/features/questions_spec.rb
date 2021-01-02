require 'rails_helper'

feature 'Any user can view all questions' do
  scenario do
    author = create(:user)
    questions = create_list(:question, 3, author: author)

    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title) }
  end
end

feature 'Any user can view question and answers to it' do
  scenario do
    author = create(:user)
    question = create(:question, author: author)
    answers = create_list(:answer, 4, question: question, author: author)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end

feature 'Authenticated user can ask the question' do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in_user(user)
      visit questions_path
    end

    scenario 'asks the question successfuly' do
      click_on 'Ask question'

      title = 'Question title'
      body = 'Question body'

      fill_in 'question_title', with: title
      fill_in 'question_body', with: body

      click_on 'Ask'

      expect(page).to have_content title
      expect(page).to have_content body
      expect(page).to have_content 'Question was successfuly created'
    end

    scenario 'asks the question with failure' do
      click_on 'Ask question'
      click_on 'Ask'

      expect(page).to have_content 'Title can\'t be blank'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit questions_path
    end

    scenario 'can not ask the question' do
      expect(page).to_not have_content 'Ask question'
    end
  end
end

feature 'Authenticated user can update the question', js: true do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in_user(user)
      visit questions_path
    end

    scenario 'updates the question successfuly' do
      new_title = 'New question title'
      new_body = 'New question body'

      within "#question-#{question.id}" do
        expect(page).to have_content 'Edit'
        click_on 'Edit'

        expect(page).to have_selector '.form_type_inline'
        expect(page).to have_content 'Cancel'

        fill_in 'question_title', with: new_title
        fill_in 'question_body', with: new_body

        click_on 'Save'

        expect(page).to have_content new_title
        expect(page).not_to have_selector '.form_type_inline'
      end

      expect(page).to have_content 'Question was successfully updated'

      click_on new_title

      expect(page).to have_content new_body
    end

    scenario 'updates the question with failure' do
      within "#question-#{question.id}" do
        expect(page).to have_content 'Edit'
        click_on 'Edit'

        fill_in 'question_title', with: ''
        fill_in 'question_body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      expect(page).to have_content 'Title can\'t be blank'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit questions_path
    end

    scenario 'can not update the question' do
      expect(page).to_not have_content 'Edit'
    end
  end
end

feature 'Authenticated user can delete the question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in_user(user)
      visit questions_path
    end

    scenario 'deletes the question' do
      question = create(:question, author: user)

      visit questions_path

      within "#question-#{question.id}" do
        expect(page).to have_content question.title
        click_on 'Delete'
      end

      expect(page).not_to have_content question.title
      expect(page).to have_content 'Question was successfully deleted'
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit questions_path
    end

    scenario 'can not delete the question' do
      expect(page).to_not have_content 'Delete'
    end
  end
end
