class Profile::AboutController < Profile::BaseController
    include Pagy::Backend

  
    def index
      authorize [@contact, About]
    
    end
  


  end
  