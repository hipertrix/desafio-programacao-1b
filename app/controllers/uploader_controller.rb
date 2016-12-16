class UploaderController < ApplicationController


  def index 

  	#-- clean data for tests
  	if params[:clean]
  		Sale.delete_all
  	end

  	#-- Get all sales on database
  	@sales = Sale.all.order(created_at: :asc)

  	#-- Summary data
  	total = 0
  	@sales.each {|s| total += s[:price] }
  	@summary= {total: total, amount: @sales.size}  

  end 
 





	## 
	# The detailed form of data processing was not specified. 
	# For this case we will write the information one by one in the database 
	#  in order to discover failures in each record.
	#
  # Another way would be to upload everything at once into a single "INSERT" 
  # but if you have errors no data will be recorded and the entire file should be reviewed.
  #
  # Therefore, this script goes up one by one to the database, 
  # in case of failure it identifies the error and generates log information 
  # for the client to adjust only that error.
  #
  # A validation has been inserted to avoid duplicate records if the file is sent again.
  #  Unfortunately this slows down the process, but makes it safer.
  #
  # Another fact that I am not taking into consideration is that if the file is large, 
  # it must be processed in a separate "JOB", not to condemn the system. 
  # In order to fulfill what was requested more quickly, I am not addressing this fact.
 
  def upload


  	if !params[:upload]

  		#-- Verify the upload is false, and redirect to start page. Then display notice.
  		flash[:notice] = "Envie um arquivo para processar"
  		redirect_to uploader_index_path and return 

  	else

	  	@errors_log = []
	  	line_number = 0  
	  	enable_duplicity = upload_params[:enable_duplicity].to_i rescue 0  

	  	# encoding UTF-8 file
	  	contents = upload_params[:file].read.force_encoding("UTF-8") 

	  	# check file is .txt
			if upload_params[:file].content_type == 'text/plain' 

				# Verify file size
				if (upload_params[:file].size.to_f / ($system[:max_file_size].to_f*1024.0) ) > 1
 					@errors_log << set_log_line(0, "O arquivo não pode ser maior que #{$system[:max_file_size]} Mb.")
		  	else


					# file lines (Split lines by \n)
					contents.split("\n").each do |line|  
						line_number += 1  

						#- Process only after the first line
						if line_number > 1 # 

							items = line.split("\t") #Split text by \t (TAB) to get cols

							enable_to_register = true # default value 

							 
							if items[2].to_s.index(",") 
								@errors_log << set_log_line(line_number, "O valor deve ter . (ponto) como separador decimal.") 
								enable_to_register = false
							end
							  

							#- check consistency of cols
							if items.size != 6
								@errors_log << set_log_line(line_number, "Verifique as colunas desta linha.") 
								enable_to_register = false
							else
								#- check consistency of cols types numbers
								unless (items[2].to_d > 0 and items[3].to_i > 0)
									@errors_log << set_log_line(line_number, "Verifique os campos numéricos") 
									enable_to_register = false
								end
							end


							#-- check if exists
							if enable_duplicity == 0 and enable_to_register
								exists = Sale.where(price: items[2].to_d, amount: items[3].to_i, description: items[1].to_s, buyer: items[0].to_s).first
								if exists
									@errors_log << set_log_line(line_number, "Esta venda já foi inserida") 
									enable_to_register = false
								end
							end 


							# if the enable_to_register is true, try create a new sale
							if enable_to_register  

								sale = Sale.new
								sale.buyer = items[0].to_s 
								sale.description = items[1].to_s
								sale.price =  items[2].to_d
								sale.amount = items[3].to_i
								sale.address = items[4].to_s
								sale.provider = items[5].to_s

								unless sale.save  
									msg = ""
									sale.errors.full_messages.each do |message|  
										   msg << "<br />" if msg != ""
			                 msg  << message
			            end 
			            @errors_log <<  set_log_line(line_number, msg.html_safe) 
								end 
								 
							end


						end 
				  end  

				end

			else
				@errors_log << set_log_line(0, "O arquivo precisa estar no fromato TXT." )
			end 

		end

  end  



  private

  #-- Create a log style (line: number, process: true/false, errors: string)
  def set_log_line(line, errors=nil)
  	{ line: line, message: errors }
  end  

	def upload_params 
		params.require(:upload).permit(:file, :file_text, :enable_duplicity) 
	end

end
