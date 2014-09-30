Rails.application.routes.draw do

  mount Integration::Engine => "/integration"
end
