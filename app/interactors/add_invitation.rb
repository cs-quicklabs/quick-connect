class AddInvitation < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params, user)
    @invite = User.new(params)
    @invitation = Invitation.new(params)
    @user = user
  end

  def call
    begin
      add_invitation
      create_user
      invite_user
      add_event
    rescue
      invite
    end
    invite
  end

  private

  def invite
    add_invitation
    create_user
    invite_user
    add_event
  end

  def add_invitation
    @invitation.user = user
    @invitation.account = user.account
    @invitation.save
  end

  def create_user
    password = random_password
    invite.account = user.account
    invite.password = password
    invite.skip_confirmation!
    invite.save!
  end

  def invite_user
    invite.invite!
  end

  def random_password(length = 10)
    CHARS.sort_by { rand }.join[0...length]
  end

  def add_event
    user.events.create(user: user, action: "created", action_for_context: "added new user", trackable: user)
  end

  attr_reader :invitation, :user, :invite
end
