Foreman::Application.routes.draw do
  mount Integration::Engine, :at => '/abcde', :as => 'integration'
end