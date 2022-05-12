class Contact::AboutController < Contact::BaseController
  include Pagy::Backend

  def index
    authorize [@contact, About]
  end
end
