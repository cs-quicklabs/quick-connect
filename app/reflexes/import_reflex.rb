class ImportReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def save
    binding.irb
    result = Contact.insert_all(element.dataset["contacts"])
    binding.irb
  end
end
