class LinkController < ApplicationController
	def index
	end
	
	def show
		@link = Link.find_by_slug(params[:slug]) 
		day_diff=(DateTime.now.utc.to_date - @link.created_at.to_date).to_i
		if @link.nil? || day_diff > 30 #if day difference is greater than 30 days then it seems like url in expired
			render 'page_404', status: 404 
		else		
			response = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
			@link.update_attribute(:clicked, @link.clicked + 1)
			localhost_ip_address=request.remote_ip
			localhost_ip_address="127.0.0.1" if request.remote_ip == "::1"
			country_name = Geocoder.search(response)
			Analytic.create(slug_id: @link.id, ip_address: localhost_ip_address, country_name: country_name[0].data["country"])
			redirect_to @link.url
		end
	end
	
	def get_shorten_url
		main_url=params[:main_url]
		short_link=Link.shorten(main_url)
		render :plain=>short_link
	end
	
	def page_404
		#404 page when link not exist
	end
	
	def get_analytics_data
		@get_analytics_data=Link.get_analytics_data
	end
end
