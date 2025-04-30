class Link < ApplicationRecord
  belongs_to :user
  validates_presence_of :link
  belongs_to :contact
  PROFILE_OPTIONS = [
    ["LinkedIn", "fa-brands fa-linkedin"],
    ["Youtube", "fa-brands fa-youtube"],
    ["Facebook", "fa-brands fa-facebook"],
    ["Instagram", "fa-brands fa-instagram"],
    ["Whatsapp", "fa-brands fa-whatsapp"],
    ["Twitter", "fa-brands fa-twitter"],
    ["Hubspot", "fa-brands fa-hubspot"],
  ]
  validates :link_type, uniqueness: { :scope => [:contact_id], message: "already exists" }
end
