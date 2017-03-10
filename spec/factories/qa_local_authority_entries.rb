FactoryGirl.define do
  factory :qa_local_authority_entry, class: 'Qa::LocalAuthorityEntry' do
    local_authority nil
    label "MyString"
    uri "MyString"
  end
end
