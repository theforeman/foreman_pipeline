object @environment => :environment

extends 'katello/api/v2/common/identifier'

attributes :library

extends 'katello/api/v2/common/timestamps'

node :prior do |env|
  if env.prior
    {name: env.prior.name, :id => env.prior.id}
  end
end

node :successor do |env|
  if !env.library && env.successor
    {name: env.successor.name, :id => env.successor.id}
  end
end