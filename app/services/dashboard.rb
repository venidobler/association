# app/services/dashboard.rb
class Dashboard
  def initialize(user)
    @user = user
  end

  def active_people_pie_chart
    Rails.cache.fetch("active_people_pie_chart", expires_in: 1.hour) do
      {
        active: active_people_count(true),
        inactive: active_people_count(false)
      }
    end
  end

  def total_debts
    Rails.cache.fetch("total_debts", expires_in: 1.hour) do
      Debt.where(person_id: active_people_ids).sum(:amount)
    end
  end

  def total_payments
    Rails.cache.fetch("total_payments", expires_in: 1.hour) do
      Payment.where(person_id: active_people_ids).sum(:amount)
    end
  end

  def balance
    total_payments - total_debts
  end

  def last_debts
    Rails.cache.fetch("last_debts", expires_in: 1.hour) do
      Debt.order(created_at: :desc).limit(10).pluck(:id, :amount)
    end
  end

  def last_payments
    Rails.cache.fetch("last_payments", expires_in: 1.hour) do
      Payment.order(created_at: :desc).limit(10).pluck(:id, :amount)
    end
  end

  def my_people
    Person.where(user: @user).order(:created_at).limit(10)
  end

  def top_person
    Rails.cache.fetch("top_person", expires_in: 1.hour) do
    people = Person.order(balance: :desc)
    people.first
    end
  end

  def bottom_person
    Rails.cache.fetch("bottom_person", expires_in: 1.hour) do
    people = Person.order(balance: :asc)
    people.first
    end
  end

  def people100k
    Debt.where("amount > 100000").includes(:person).order(created_at: :desc).limit(10)
  end

  private

  def active_people_count(active)
    Person.where(active: active).count
  end

  def active_people_ids
    Person.where(active: true).select(:id)
  end
end
