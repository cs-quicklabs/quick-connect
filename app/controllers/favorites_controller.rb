class FavoritesController < BaseController
  def index
    authorize :favorite
    @pagy, @favorites = pagy_nil_safe(params, Contact.available.favorites.includes(:labels, :events), items: LIMIT)
    render_partial("contacts/contact", collection: @favorites, cached: true) if stale?(@favorites)
  end
end
