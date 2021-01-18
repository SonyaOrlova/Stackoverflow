FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }

    trait :invalid do
      body { nil }
    end

    trait :with_files_attached do
      before :create do |answer|
        answer.files.attach Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb'))
        answer.files.attach Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb'))
      end
    end
  end
end
