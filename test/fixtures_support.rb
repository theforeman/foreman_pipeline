module ForemanPipeline
  module FixturesSupport
    FIXTURE_CLASSES = {
      :jobs => ForemanPipeline::Job,
      :jenkins_instances => ForemanPipeline::JenkinsInstance,
      :jenkins_users => ForemanPipeline::JenkinsUser,
      :jenkins_projects => ForemanPipeline::JenkinsProject,
      :pipeline_hostgroups => Hostgroup,
      :pipeline_compute_profiles => ComputeProfile,
      :pipeline_compute_attributes => ComputeAttribute,
    }

    def self.set_fixture_classes(test_class)
      FIXTURE_CLASSES.each { |k, v| test_class.set_fixture_class(k => v) }
    end
  end
end
