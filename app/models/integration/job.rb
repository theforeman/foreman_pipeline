
module Integration
  class Job < Katello::Model
    self.include_root_in_json = false

    attr_accesible :name

    belongs_to :content_view
    belongs_to :hostgroup
    
    validates :content_view, :presence => true
    validates :hostgroup, :presence => true
    validates :name, :presence => true

  end
end