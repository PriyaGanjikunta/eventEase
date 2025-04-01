class ChangeStatusDefaultInPayments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :payments, :status, "pending"
    change_column_null :payments, :status, false
  end
end
