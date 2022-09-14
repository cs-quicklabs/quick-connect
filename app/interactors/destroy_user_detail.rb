class DestroyUserDetail < Patterns::Service
  def initialize(actor, detail)
    @detail = detail
    @actor = actor
  end

  def call
    begin
      destroy_detail
      update_event
    rescue
      detail
    end

    detail
  end

  private

  def destroy_detail
    @detail.destroy
  end

  def update_event
    Event.where(trackable: @detail).touch_all
    Event.create(user: actor, action: "deleted", action_for_context: "deleted a " + detail.class.model_name.downcase)
  end

  attr_reader :detail, :actor
end
