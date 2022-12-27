class Link < ApplicationRecord
  belongs_to :user
  validates_presence_of :link
  belongs_to :contact
  normalize_attribute :title, :body, :with => :strip
  PROFILE_OPTIONS = [
    ["Youtube", "fa-brands fa-youtube"],
    ["Facebook", "fa-brands fa-facebook"],
    ["Instagram", "fa-brands fa-instagram"],
    ["Whatsapp", "fa-brands fa-whatsapp"],
    ["Twitter", "fa-brands fa-twitter"],
    ["Linkedin", "fa-brands fa-linkedin"],
  ]
  validates :link, uniqueness: { :scope => [:contact_id, :link_type], message: "already exists" }
end
