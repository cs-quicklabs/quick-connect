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
      set_stripe_subscription_trial
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
      Relation.insert_all([{ name: "significant other", default: "TRUE" }, { name: "Husband/Wife", default: "TRUE" }, { name: "date", default: "TRUE" }, { name: "lover", default: "TRUE" }, { name: "is in love with", default: "TRUE" },
                           { name: "secret lover", default: "TRUE" }, { name: "Ex-boyfriend/Ex-girlfriend", default: "TRUE" }, { name: "Ex-husband/Ex-wife", default: "TRUE" }, { name: "friend", default: "TRUE" }, { name: "Father/Mother", default: "TRUE" },
                           { name: "son/daughter", default: "TRUE" }, { name: "Brother/Sister", default: "TRUE" }, { name: "Grandfather/Grandmother", default: "TRUE" }, { name: "Grandson/Granddaughter", default: "TRUE" }, { name: "Uncle/Aunt", default: "TRUE" }, { name: "Nephew/Niece", default: "TRUE" }, { name: "cousin", default: "TRUE" },
                           { name: "Godmother/Godfather", default: "TRUE" }, { name: "Godson/Goddaughter", default: "TRUE" }, { name: "Step-father/Step-mother", default: "TRUE" }, { name: "Stepson/Stepdaughter", default: "TRUE" },
                           { name: "best friend", default: "TRUE" }, { name: "colleague", default: "TRUE" }, { name: "boss", default: "TRUE" }, { name: "subordinate", default: "TRUE" }, { name: "mentor", default: "TRUE" }, { name: "protégé", default: "TRUE" }])
      Activity.insert_all([{ name: "just hung out", group_id: groups.values_at(0).first.id, default: "TRUE" }, { name: "watched a movie at home", group_id: groups.values_at(0).first.id, default: "TRUE" }, { name: "just talked at home", group_id: groups.values_at(0).first.id, default: "TRUE" },
                           { name: "played a sport together", group_id: groups.values_at(1).first.id, default: "TRUE" }, { name: "ate at their place", group_id: groups.values_at(2).first.id, default: "TRUE" }, { name: "went to a bar", group_id: groups.values_at(2).first.id, default: "TRUE" },
                           { name: "ate at home", group_id: groups.values_at(2).first.id, default: "TRUE" }, { name: "picnicked", group_id: groups.values_at(2).first.id, default: "TRUE" }, { name: "ate at a restaurant", group_id: groups.values_at(2).first.id, default: "TRUE" }, { name: "went to a theater", group_id: groups.values_at(3).first.id, default: "TRUE" },
                           { name: "went to a concert", group_id: groups.values_at(3).first.id, default: "TRUE" }, { name: "went to a play", group_id: groups.values_at(3).first.id, default: "TRUE" }, { name: "went to the museum", group_id: groups.values_at(3).first.id, default: "TRUE" }, { name: "other", group_id: groups.values_at(9).first.id, default: "TRUE" }, { name: "Online meeting", group_id: groups.values_at(11).first.id, default: "TRUE" }, { name: "Meeting in Office ", group_id: groups.values_at(11).first.id, default: "TRUE" }, { name: "Met in Conference", group_id: groups.values_at(11).first.id, default: "TRUE" }])
      LifeEvent.insert_all([{ name: "started a new job", group_id: groups.values_at(4).first.id, default: "TRUE" }, { name: "retired", group_id: groups.values_at(4).first.id, default: "TRUE" }, { name: "started school", group_id: groups.values_at(4).first.id, default: "TRUE" },
                            { name: "studied abroad", group_id: groups.values_at(4).first.id, default: "TRUE" }, { name: "started voluteering", group_id: groups.values_at(4).first.id, default: "TRUE" }, { name: "published a paper", group_id: groups.values_at(4).first.id, default: "TRUE" },
                            { name: "started a military service", group_id: groups.values_at(4).first.id, default: "TRUE" }, { name: "started a relationship", group_id: groups.values_at(5).first.id, default: "TRUE" }, { name: "got engaged", group_id: groups.values_at(5).first.id, default: "TRUE" }, { name: "got married", group_id: groups.values_at(5).first.id, default: "TRUE" },
                            { name: "aniversary", group_id: groups.values_at(5).first.id, default: "TRUE" }, { name: "expects a baby", group_id: groups.values_at(5).first.id, default: "TRUE" }, { name: "had a child", group_id: groups.values_at(5).first.id, default: "TRUE" }, { name: "added a family member", group_id: groups.values_at(6).first.id, default: "TRUE" },
                            { name: "got a pet", group_id: groups.values_at(5).first.id, default: "TRUE" }, { name: "ended a relationship", group_id: groups.values_at(5).first.id, default: "TRUE" }, { name: "lost a loved one", group_id: groups.values_at(5).first.id, default: "TRUE" }, { name: "moved", group_id: groups.values_at(6).first.id, default: "TRUE" }, { name: "bought a home", group_id: groups.values_at(6).first.id, default: "TRUE" },
                            { name: "made a home improvement", group_id: groups.values_at(6).first.id, default: "TRUE" }, { name: "went on holidays", group_id: groups.values_at(6).first.id, default: "TRUE" }, { name: "got a new vehicle", group_id: groups.values_at(6).first.id, default: "TRUE" }, { name: "got a roommate", group_id: groups.values_at(6).first.id, default: "TRUE" },
                            { name: "overcame an illness", group_id: groups.values_at(7).first.id, default: "TRUE" }, { name: "quit a habit", group_id: groups.values_at(7).first.id, default: "TRUE" }, { name: "started new eating habits", group_id: groups.values_at(7).first.id, default: "TRUE" }, { name: "lost weight", group_id: groups.values_at(7).first.id, default: "TRUE" }, { name: "started to wear glass or contact lenses", group_id: groups.values_at(7).first.id, default: "TRUE" },
                            { name: "broke a bone", group_id: groups.values_at(7).first.id, default: "TRUE" }, { name: "had surgery", group_id: groups.values_at(7).first.id, default: "TRUE" }, { name: "went to the dentist", group_id: groups.values_at(7).first.id, default: "TRUE" },
                            { name: "started a sport", group_id: groups.values_at(8).first.id, default: "TRUE" }, { name: "started a hobby", group_id: groups.values_at(8).first.id, default: "TRUE" }, { name: "learned a new instrument", group_id: groups.values_at(8).first.id, default: "TRUE" }, { name: "learned a new language", group_id: groups.values_at(8).first.id, default: "TRUE" },
                            { name: "got a tattoo or piercing", group_id: groups.values_at(8).first.id, default: "TRUE" }, { name: "got a license", group_id: groups.values_at(8).first.id, default: "TRUE" }, { name: "traveled", group_id: groups.values_at(8).first.id, default: "TRUE" }, { name: "got an achivement or award", group_id: groups.values_at(8).first.id, default: "TRUE" },
                            { name: "changed beliefs", group_id: groups.values_at(8).first.id, default: "TRUE" }, { name: "other", group_id: groups.values_at(10).first.id, default: "TRUE" }])
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
