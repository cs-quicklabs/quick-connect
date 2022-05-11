class AddRelative < Patterns::Service
    CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a
  
    def initialize(params, actor, contact)
      @relative = Relative.new(params)
      @actor = actor
      @contact = contact
    end
  
    def call
      add_relative
      add_event
      begin

     
      rescue
        contact
      end
      contact
    end
  
    private
  
    def add_relative
      relative.save!
    end
  
    def add_event
      @contact.events.create(user: actor, action: "relative", action_for_context: "added a relation to contact", trackable: relative)
    end
  
  
    attr_reader :contact, :actor, :relative
  end
  