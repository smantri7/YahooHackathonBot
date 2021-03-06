Rails.application.routes.draw do

  root 'main_page#top'

  get '/' => 'main_page#top'
  
  get 'main_page/top' => 'main_page#top'

  get 'main_page/index' => 'main_page#index'

  get 'main_page/chat' => 'main_page#chat'

  post 'main_page/chat' => 'main_page#chat'

  post 'main_page/create' => 'main_page#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
