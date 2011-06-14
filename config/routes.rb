
Rails.application.routes.draw do |map|

  resources :hashblue, :only => [:index, :code]

end
