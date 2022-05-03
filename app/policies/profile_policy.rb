class ProfilePolicy < Struct.new(:user, :surveys)
    def index?
      true
    end

end