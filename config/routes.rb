Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get '/', to:'link#index'
	
	get 'get_shorten_url', to:'link#get_shorten_url'
	
	get 'page_404', to:'link#page_404'
	
	get '/test/test_page', to:'link#test'
	
	get '/stats', to:'link#get_analytics_data'
	
	get '/s/:slug', to: 'link#show', as: :short
end
