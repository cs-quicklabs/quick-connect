class SignUp < Patterns::Service
  require "securerandom"

  def initialize(user)
    @account = Account.new
    @user = user
  end

  def call
    begin
      register
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
      seed_database
      #set_stripe_subscription_trial
    end
  end

  def create_account
    account.name = user.first_name + " " + user.last_name
    account.save!
  end

  def seed_database
    now = Time.now
    groups = Group.all.uniq.to_a
    ActsAsTenant.with_tenant(account) do
      Field.insert_all([{ name: "Email", icon: "far fa-envelope-open", protocol: "mailto:", default: "TRUE" },
                        { name: "Facebook", icon: "fa-brands fa-facebook-square", protocol: "https://facebook.com", default: "TRUE" },
                        { name: "Phone", icon: "fa-solid fa-phone-volume", protocol: "tel:", default: "TRUE" },
                        { name: "Twitter", icon: "fa-brands fa-twitter-square", protocol: "", default: "TRUE" },
                        { name: "Whatsapp", icon: "fa-brands fa-whatsapp", protocol: "https://wa.me", default: "TRUE" },
                        { name: "Telegram", icon: "fa-brands fa-telegram", protocol: "telegram:", default: "TRUE" },
                        { name: "LinkedIn", icon: "fa-brands fa-linkedin", protocol: "", default: "TRUE" }])

    end
  end

  def create_user
    ActsAsTenant.with_tenant(account) do
      if user.email == "e2e.testing@yopmail.com" && user.password == "password"
        user.confirmation_token = ""
        user.confirmed_at = Time.now
      end
      user.account = account
      user.jti ||= SecureRandom.uuid
      user.save!
    end
    account.update!(owner_id: user.id)
  end

  def set_stripe_subscription_trial
    time = 14.days.from_now
    user.set_payment_processor :fake_processor, allow_fake: true
    user.payment_processor.subscribe(trial_ends_at: time, ends_at: time)
  end

  attr_reader :account, :user
end
