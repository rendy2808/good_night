FactoryBot.define do
  factory :user do
    name { SecureRandom.alphanumeric(10) } 
  end
end
