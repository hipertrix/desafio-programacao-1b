require 'rails_helper'

 
 describe Sale do 

 	 # Test integrity of model 

	  it { is_expected.to validate_presence_of(:buyer) }
	  it { is_expected.to validate_presence_of(:description) }
	  it { is_expected.to validate_presence_of(:price) }
	  it { is_expected.to validate_presence_of(:amount) }  
	  it { is_expected.to validate_presence_of(:address) }  
	  it { is_expected.to validate_presence_of(:provider) }    


	  it { is_expected.to validate_numericality_of(:amount) }   
	  it { is_expected.to validate_numericality_of(:price) } 

	  it { is_expected.to  validate_length_of(:buyer).is_at_most(70) }
	  it { is_expected.to  validate_length_of(:description).is_at_most(100) }
	  it { is_expected.to  validate_length_of(:address).is_at_most(100) }
	  it { is_expected.to  validate_length_of(:provider).is_at_most(70) }

	  it { is_expected.to  validate_length_of(:buyer).is_at_least(3) }
	  it { is_expected.to  validate_length_of(:description).is_at_least(3) }
	  it { is_expected.to  validate_length_of(:address).is_at_least(3) }
	  it { is_expected.to  validate_length_of(:provider).is_at_least(3) } 
	  
	
end
 