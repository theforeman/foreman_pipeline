Integration::Engine.routes.draw do
  match '/home' => 'basic#home', :via => :get
end
