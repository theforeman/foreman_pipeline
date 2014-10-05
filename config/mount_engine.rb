Foreman::Application.routes.draw do
  mount Integration::Engine, :at => '/', :as => 'integration'
end