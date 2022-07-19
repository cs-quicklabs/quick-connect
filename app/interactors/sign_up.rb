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
                        { name: "child/daughter", default: "TRUE" }, { name: "sibling/sister", default: "TRUE" }, { name: "grandparent/grandmother", default: "TRUE" }, { name: "grandchild/granddaughter", default: "TRUE" }, { name: "uncle/aunt", default: "TRUE" }, { name: "nephew/niece", default: "TRUE" }, { name: "cousin", default: "TRUE" },
                        { name: "godparent/godfather", default: "TRUE" }, { name: "godchild/goddaughter", default: "TRUE" }, { name: "step-parent/stepmother", default: "TRUE" }, { name: "stepchild/stepdaughter", default: "TRUE" },
                        { name: "best friend", default: "TRUE" }, { name: "colleague", default: "TRUE" }, { name: "boss", default: "TRUE" }, { name: "subordinate", default: "TRUE" }, { name: "mentor", default: "TRUE" }, { name: "protégé", default: "TRUE" }])
      Activity.create!([{ name: "just hung out", group_id: 1 }, { name: "watched a movie at home", group_id: 1 }, { name: "just talked at home", group_id: 1 },
                        { name: "played a sport together", group_id: 2 }, { name: "ate at their place", group_id: 3 }, { name: "went to a bar", group_id: 3 },
                        { name: "ate at home", group_id: 3 }, { name: "picnicked", group_id: 3 }, { name: "ate at a restaurant", group_id: 3 }, { name: "went to a theater", group_id: 4 },
                        { name: "went to a concert", group_id: 4 }, { name: "went to a play", group_id: 4 }, { name: "went to the museum", group_id: 4 }])
      LifeEvent.create!([{ name: "started a new job", group_id: 5 }, { name: "retired", group_id: 5 }, { name: "started school", group_id: 5 },
                         { name: "studied abroad", group_id: 5 }, { name: "started voluteering", group_id: 5 }, { name: "published a paper", group_id: 5 },
                         { name: "started a military service", group_id: 5 }, { name: "started a relationship", group_id: 6 }, { name: "got engaged", group_id: 6 }, { name: "got married", group_id: 6 },
                         { name: "aniversary", group_id: 6 }, { name: "expects a baby", group_id: 6 }, { name: "had a child", group_id: 6 }, { name: "added a family member", group_id: 7 },
                         { name: "got a pet", group_id: 6 }, { name: "ended a relationship", group_id: 6 }, { name: "last a loved one", group_id: 6 }, { name: "moved", group_id: 7 }, { name: "bought a home", group_id: 7 },
                         { name: "made a home improvement", group_id: 7 }, { name: "went on holidays", group_id: 7 }, { name: "got a new vehicle", group_id: 7 }, { name: "got a roommate", group_id: 7 },
                         { name: "overcame an illness", group_id: 8 }, { name: "quit a habit", group_id: 8 }, { name: "started new eating habits", group_id: 8 }, { name: "lost weight", group_id: 8 }, { name: "started to wear glass or contact lenses", group_id: 8 },
                         { name: "broke a bone", group_id: 8 }, { name: "had surgery", group_id: 8 }, { name: "went to the dentist", group_id: 8 },
                         { name: "started a sport", group_id: 9 }, { name: "started a hobby", group_id: 9 }, { name: "learned a new instrument", group_id: 9 }, { name: "learned a new language", group_id: 9 },
                         { name: "got a tattoo or piercing", group_id: 9 }, { name: "got a license", group_id: 9 }, { name: "traveled", group_id: 9 }, { name: "got an achivement or award", group_id: 9 },
                         { name: "changed beliefs", group_id: 9 }])
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
