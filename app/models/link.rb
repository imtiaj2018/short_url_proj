class Link < ApplicationRecord
	before_validation :generate_slug
	validates_presence_of :url
	validates :url, format: URI::regexp(%w[http https])
	validates_uniqueness_of :slug
	validates_length_of :url, within: 3..255, on: :create, message: "too long"
	validates_length_of :slug, within: 3..255, on: :create, message: "too long"
	
	def short
		Rails.application.routes.url_helpers.short_url(slug: self.slug, host: "localhost:3000")
	end
	
	def generate_slug
		self.slug = SecureRandom.alphanumeric[0..4] if self.slug.nil? || self.slug.empty?
		true
	end
	
	def self.shorten(url,slug = '')
		link = Link.where(url: url, slug: slug).first
		return link.short if link 

		# create a new
		link = Link.new(url: url, slug: slug)
		link.short_link=link.short
		return link.short if link.save
	end
	
	def self.get_analytics_data #for stats to get the analytics data
		return Link.find_by_sql("SELECT lin.url, lin.slug,lin.short_link,lin.clicked, GROUP_CONCAT(DISTINCT ana.country_name) AS c_name FROM links lin,analytics ana WHERE ana.slug_id=lin.id GROUP BY ana.slug_id")
	end
end
