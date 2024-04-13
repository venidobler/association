class Payment < ApplicationRecord
  belongs_to :person
  after_create :update_person_balance

  private

  def update_person_balance
    self.person.update_balance
  end
end