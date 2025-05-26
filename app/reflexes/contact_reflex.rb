class ContactReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def export
    html = render(partial: "account/export/export")
    morph "#export", "#{html}"
  end
end
