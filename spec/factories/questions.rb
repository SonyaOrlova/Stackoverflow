FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question #{n} title" }
    sequence(:body) { |n| "Question #{n} body" }

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :with_files_attached do
      before :create do |question|
        question.files.attach Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb'))
        question.files.attach Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb'))
      end
    end
  end
end
