class AddInvitation < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params, user)
    @invitation = Invitation.new(params)
    @invite = User.new(params)
    @user = user
  end

  def call
    begin
      add_invitation
      create_user
      invite_user
      add_event
    rescue
      invitation
    end
    invitation
  end

  private

  def add_invitation
    @invitation.sender = user
    @invitation.account = user.account
    @invitation.save!
  end

  def create_user
    password = random_password
    invite.account = user.account
    invite.invited_by = user
    invite.password = password
    invite.skip_confirmation!
    invite.save!
    @invitation.update!(user: invite)
  end

  def invite_user
    invite.invite!
  end

  def random_password(length = 10)
    CHARS.sort_by { rand }.join[0...length]
  end

  def add_event
    user.events.create(user: user, action: "invited", action_for_context: "added new user", trackable: invitation)
  end

  attr_reader :invitation, :user, :invite
end
