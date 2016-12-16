require 'rails_helper'
 

RSpec.describe UploaderController, type: :controller do

  ##
  # Load the files to test upload
  before :each do
    @file_ok = fixture_file_upload('files/dados.txt', 'text/plain')
    @file_invalid = fixture_file_upload('files/dados-invalid.txt', 'text/plain') 
    @file_big = fixture_file_upload('files/dados-big.txt', 'text/plain') 
    @file_invalid_type = fixture_file_upload('files/dados-invalid-type.csv', 'text/csv')
  end


  ##
  # this small test for routes index
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end



  ##
  # Now test the upload controller
  # The num_itens_on_file var represents a size of file lines, except the header
  # In the original file, this is 4, if you want to change this, 
  # rewrite your files/data.txt and change the value of this variable.
  
  describe "POST #upload" do  

    context "with valid attributes" do
      it "Upload - enable_duplicity = 0" do
        num_itens_on_file = 4
        count_itens = Sale.count 
        count_itens = (count_itens==0 ? num_itens_on_file : count_itens)
        post :upload, upload: {file: @file_ok, enable_duplicity: "0"} 
        expect(Sale.count).to eq(count_itens)
      end
     
      it "Upload - enable_duplicity = 1" do
        num_itens_on_file = 4
        count_itens = Sale.count  
        post :upload, upload: {file: @file_ok, enable_duplicity: "1"} 
        expect(Sale.count).to eq(count_itens + num_itens_on_file)
      end
    end 




    context "with invalid attributes" do
      it "Upload - enable_duplicity = 0" do 
        count_itens = Sale.count  
        post :upload, upload: {file: @file_invalid, enable_duplicity: "0"} 
        expect(Sale.count).to eq(count_itens)
      end
     
      it "Upload - enable_duplicity = 1" do 
        count_itens = Sale.count  
        post :upload, upload: {file: @file_invalid, enable_duplicity: "1"} 
        expect(Sale.count).to eq(count_itens)
      end
      
      it "Upload a big file" do 
        count_itens = Sale.count  
        post :upload, upload: {file: @file_big, enable_duplicity: "1"} 
        expect(Sale.count).to eq(count_itens)
      end

      it "Upload a invalid type file" do 
        count_itens = Sale.count  
        post :upload, upload: {file: @file_invalid_type, enable_duplicity: "1"} 
        expect(Sale.count).to eq(count_itens)
      end 

    end 

 
  end  
end
