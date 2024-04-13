class Debt < ApplicationRecord
  belongs_to :person
  after_create :update_person_balance

  validates :amount, presence: true

  private

  def update_person_balance
    self.person.update_balance
  end
end