require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:created_questions).dependent(:destroy) }
  it { should have_many(:created_answers).dependent(:destroy) }
end
