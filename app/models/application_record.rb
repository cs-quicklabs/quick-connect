class ApplicationRecord < ActiveRecord::Base
  include CableReady::Updatable
  self.abstract_class = true
end
