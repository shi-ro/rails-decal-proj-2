class Tag < ActiveRecord::Base

	has_and_belongs_to_many :users
	has_and_belongs_to_many :posts
	searchkick
end
