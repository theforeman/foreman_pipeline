FactoryGirl.define do
  factory :pipeline_organization, :class => Organization do
    sequence(:name) { |n| "pipeline_organization#{n}"}
  end

  factory :jenkins_user, :class => ForemanPipeline::JenkinsUser do
    sequence(:name) { |n| "jenkins_user#{n}"}
    token "abcde"
    organization
  end

  factory :jenkins_instance, :class => ForemanPipeline::JenkinsInstance do
    sequence(:name) { |n| "jenkins.random#{n}"}
    sequence(:cert_path) { |n| "/var/lib/file#{n}" }
    sequence(:url) { |n| "http://jenkins.random#{n}.com:8080" }
    organization
    jenkins_home "/var/lib/jenkins"
    jenkins_user
  end
end