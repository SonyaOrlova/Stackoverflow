require 'rails_helper'

feature 'User can answer to question' do
  given(:question) { create(:question) }

  background do
    visit question_path(question)
  end

  scenario 'answers the question successfuly' do
    body = 'Answer body'

    fill_in 'answer_body', with: body

    click_on 'Reply'

    expect(find('.question__answers-list')).to have_content body
  end

  scenario 'answers the question with failure' do
    click_on 'Reply'

    expect(page).to have_content 'Body can\'t be blank'
  end
end
