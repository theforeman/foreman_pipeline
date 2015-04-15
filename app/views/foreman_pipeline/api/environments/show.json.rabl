object @environment => :environment

extends 'katello/api/v2/common/identifier'

attributes :library

extends 'katello/api/v2/common/timestamps'

child :successors => :successors do |env|
  attributes :name, :id, :label, :library
end