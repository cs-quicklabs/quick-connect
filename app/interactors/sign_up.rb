class SignUp < Patterns::Service
  require "securerandom"

  def initialize(user)
    @account = Account.new
    @user = user
  end

  def call
    register
    begin
    rescue
      user
    end
    user
  end

  private

  def register
    ActiveRecord::Base.transaction do
      create_account
      create_user
    end

    def set_stripe_subscription_trial
      time = 14.days.from_now
      user.set_payment_processor :fake_processor, allow_fake: true
      user.payment_processor.subscribe(trial_ends_at: time, ends_at: time)
    end
  end

  def create_account
    account.name = user.first_name + " " + user.last_name
    account.save!
  end

  def create_user
    ActsAsTenant.with_tenant(account) do
      user.account = account
      user.jti ||= SecureRandom.uuid
      user.save!
    end
  end

  attr_reader :account, :user
end
