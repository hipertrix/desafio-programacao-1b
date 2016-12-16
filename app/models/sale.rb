class Sale < ActiveRecord::Base

 
	##
	# There was no definition of sizes and mandatory fields (on README.md), so I'm making a.
	# Validations 
	validates_presence_of :buyer, :description, :price, :amount, :address, :provider 
	validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { only_float: true, greater_than: 0 }
	validates :amount, numericality: { only_integer: true , greater_than: 0} 
	validates_length_of :buyer, :minimum => 3, :maximum => 70 
	validates_length_of :description, :minimum => 3, :maximum => 100 
	validates_length_of :address, :minimum => 3, :maximum => 100 
	validates_length_of :provider, :minimum => 3, :maximum => 70 


end