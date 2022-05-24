class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  scope :active, -> { where(active: true) }
  scope :delivered, -> { active.where.not(delivered_at: nil) }
  scope :paid, -> { active.where.not(paid_at: nil).where(shipped_at: nil) }
  scope :not_paid, -> { active.where(paid_at: nil, delivered_at: nil) }
end
