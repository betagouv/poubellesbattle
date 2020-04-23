class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :created_before, ->(time) { where("created_at < ?", time) if time.present? }
  scope :created_after, ->(time) { where("created_at > ?", time) if time.present? }
end
