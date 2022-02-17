class Purchaser < ApplicationRecord
  has_many :orders
  has_many :vendors, through: :orders

  searchkick

  # validates :name, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 30 }

  before_destroy :check_associated_orders

  private

  def check_associated_orders
    if self.orders.any?
      self.errors.add(:base, "Unable to delete. #{self.orders.count} associated orders. You must update the orders below to a different ship before deleting.")
      throw(:abort)
    end
  end

end
