class FavoritesController < BaseController
  def index
    authorize :favorite
    @pagy, @favorites = pagy_nil_safe(params, Contact.all.favorites, items: LIMIT)
    render_partial("contacts/contact", collection: @favorites)
  end
end
