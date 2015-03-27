child :results => :results do
  child :environments => :environments do
    extends('foreman_pipeline/api/environments/show')
  end
end