class DestroyContact < Patterns::Service
  def initialize(contact)
    @contact = contact
  end

  def call
    begin
      contact.destroy
    rescue
      return false
    end
    true
  end

  private

  attr_reader :contact
end
