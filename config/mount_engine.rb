Foreman::Application.routes.draw do
  mount ForemanPipeline::Engine, :at => '/', :as => 'foreman_pipeline'
end