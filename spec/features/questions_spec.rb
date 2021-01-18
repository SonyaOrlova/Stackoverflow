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

      attach_file 'File', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]

      click_on 'Ask'

      expect(page).to have_content title
      expect(page).to have_content body
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
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

    scenario 'deletes the question file successfuly' do
      question.files.attach Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb'))
      question.reload
      visit questions_path

      within "#question-#{question.id}" do
        click_on 'Edit'

        expect(page).to have_link 'rails_helper.rb'

        click_on 'Delete file'

        expect(page).not_to have_link 'rails_helper.rb'
      end

      expect(page).to have_content 'File was successfully deleted'
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

feature 'Authenticated user author of the question can set question best answer', js: true do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }

  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 4, question: question, author: other_user) }

  describe 'Authenticated user' do
    scenario 'author of the question can set question best answer' do
      sign_in_user(user)
      visit question_path(question)

      best_answer = answers.last

      within "#answer-#{best_answer.id}" do
        expect(page).to have_content 'Mark as best'
        click_on 'Mark as best'

        expect(page).to_not have_content 'Mark as best'
      end

      expect(page).to have_css('.answer:first-child', text: best_answer.body)
      expect(page).to have_content 'Question best answer was successfully updated'
    end

    scenario 'not author of the question can not set question best answer' do
      sign_in_user(other_user)
      visit question_path(question)

      expect(page).to_not have_content 'Mark as best'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not set question best answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Mark as best'
    end
  end
end
