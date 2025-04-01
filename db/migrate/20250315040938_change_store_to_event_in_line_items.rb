class ChangeStoreToEventInLineItems < ActiveRecord::Migration[7.1]
  def change
    remove_reference :line_items, :store, foreign_key: true
    add_reference :line_items, :event, null: false, foreign_key: true
  end
end
