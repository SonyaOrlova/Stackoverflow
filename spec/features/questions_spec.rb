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

      click_on 'Ask question'
    end

    scenario 'asks the question successfuly' do
      title = 'Question title'
      body = 'Question body'

      fill_in 'question_title', with: title
      fill_in 'question_body', with: body

      click_on 'Ask'

      expect(page).to have_content 'Question was successfuly created'
      expect(page).to have_content title
      expect(page).to have_content body
    end

    scenario 'asks the question with failure' do
      click_on 'Ask'

      expect(page).to have_content 'Title can\'t be blank'
      expect(page).to have_content 'Body can\'t be blank'
    end

    scenario 'deletes the question' do
      question = create(:question, author: user)

      visit questions_path

      expect(page).to have_content question.title

      click_on 'Delete'

      expect(page).to have_content 'Question was successfully deleted'
      expect(page).not_to have_content question.title
    end
  end

  scenario 'Unauthenticated user can not ask the question' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end
end
