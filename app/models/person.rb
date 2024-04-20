class Person < ApplicationRecord
  belongs_to :user, optional: true, strict_loading: true
  has_many :debts, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :name, :national_id, presence: true
  validates :national_id, uniqueness: true
  validate :cpf_or_cnpj


  def update_balance
    update(balance: payments.sum(:amount) - debts.sum(:amount))
  end

  def cached_balance
    Rails.cache.fetch "balance#{id}" do
      payments.sum(:amount) - debts.sum(:amount)
    end
end

  def clear_balance_cache
    Rails.cache.clear "balance_#{id}"
  end

  private

  def cpf_or_cnpj
    unless CPF.valid?(national_id) || CNPJ.valid?(national_id)
      errors.add :national_id, :invalid
    end
  end
end