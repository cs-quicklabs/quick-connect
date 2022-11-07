class UpdateContact < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params, contact, groups)
    @contact = contact
    @params = params
    @groups = groups
  end

  def call
    begin
      update_contact
      update_event
      update_groups
    rescue
      contact
    end
    contact
  end

  private

  def update_contact
    @contact.update(params)
  end

  def update_event
    Event.where(eventable: @contact).touch_all
  end

  def update_groups
    contact_batches = contact.batches
    @batches = Batch.where("id IN (?)", groups)
    batch = contact_batches - @batches
    contact_batches.destroy batch
    if !@batches.nil?
      contact_batches << @batches - contact_batches
    end
  end

  attr_reader :contact, :params, :groups
end
