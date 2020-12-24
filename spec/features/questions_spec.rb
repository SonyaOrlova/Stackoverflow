require 'rails_helper'

feature 'User can view all questions' do
  scenario do
    questions = create_list(:question, 3)

    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title) }
  end
end

feature 'User can ask the question' do
  background do
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
end

feature 'User can view question and answers to it' do
  scenario do
    question = create(:question)
    answers = create_list(:answer, 4, question: question)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
