module Integration
  class JenkinsProjectParam < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue

    include Integration::Authorization::JenkinsProjectParam

    self.inheritance_column = :_inheritance_type_disabled
    belongs_to :organization
    belongs_to :jenkins_project, :class_name => "Integration::JenkinsProject"
    attr_accessible :name, :type, :description, :value

    TYPES = ["string", "boolean", "text"]
    validates :type, :inclusion => { :in => TYPES }

    def format_bool
      self.value = self.value.sub(/^t$/, "true").sub(/^f$/, "false") if type == "boolean"
    end
  end
end