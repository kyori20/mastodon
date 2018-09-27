class RemoveIndexAccountPins < ActiveRecord::Migration[5.2]
  def change
    remove_index :account_pins, name: "index_account_pins_on_account_id"
  end
end
