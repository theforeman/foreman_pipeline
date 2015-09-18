FactoryGirl.define do
  factory :pipeline_hostgroup, :class => Hostgroup do
    sequence(:name) { |n| "hostgroup#{n}" }
  end
end