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
    end

    def set_stripe_subscription_trial
      time = 14.days.from_now
      user.set_payment_processor :fake_processor, allow_fake: "TRUE"
      user.payment_processor.subscribe(trial_ends_at: time, ends_at: time)
    end
  end

  def create_account
    account.name = user.first_name + " " + user.last_name
    account.save!
  end

  def seed_database
    now = Time.now
    ActsAsTenant.with_tenant(account) do
      Field.create!([{ name: "Email", icon: "fa fa-envelope-open", protocol: "mailto:", default: "TRUE" },
                     { name: "Facebook", icon: "fa-brands fa-facebook-square", protocol: "https://facebook.com", default: "TRUE" },
                     { name: "Phone", icon: "fa-solid fa-phone-volume", protocol: "tel:", default: "TRUE" },
                     { name: "Twitter", icon: "fa-brands fa-twitter-square", protocol: "", default: "TRUE" },
                     { name: "Whatsapp", icon: "fa-brands fa-whatsapp", protocol: "https://wa.me", default: "TRUE" },
                     { name: "Telegram", icon: "fa-brands fa-telegram", protocol: "telegram:", default: "TRUE" },
                     { name: "LinkedIn", icon: "fa-brands fa-linkedin", protocol: "", default: "TRUE" }])
      Relation.create!([{ name: "significant other", default: "TRUE" }, { name: "spouse/wife", default: "TRUE" }, { name: "date", default: "TRUE" }, { name: "lover", default: "TRUE" }, { name: "is in love with", default: "TRUE" },
                        { name: "secret lover", default: "TRUE" }, { name: "ex-partner/ex-girlfriend", default: "TRUE" }, { name: "ex-spouse/ex-wife", default: "TRUE" }, { name: "friend", default: "TRUE" }, { name: "parent/mother", default: "TRUE" },
                        { name: "child/daughter", default: "TRUE" }, { name: "sibling/sister", default: "TRUE" }, { name: "grandparent/grandmother", default: "TRUE" }, { name: "grandchild/granddaughter", default: "TRUE" }, { name: "uncle/aunt", default: "TRUE" }, { name: "nephew/niece", default: "TRUE" }, { name: "couson", default: "TRUE" },
                        { name: "godparent/godfather", default: "TRUE" }, { name: "godchild/goddaughter", default: "TRUE" }, { name: "step-parent/stepmother", default: "TRUE" }, { name: "stepchild/stepdaughter", default: "TRUE" },
                        { name: "best friend", default: "TRUE" }, { name: "colleague", default: "TRUE" }, { name: "boss", default: "TRUE" }, { name: "subordinate", default: "TRUE" }, { name: "mentor", default: "TRUE" }, { name: "protégé", default: "TRUE" }])
    end
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
