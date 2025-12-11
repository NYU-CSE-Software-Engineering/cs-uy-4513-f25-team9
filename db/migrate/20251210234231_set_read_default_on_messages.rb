class SetReadDefaultOnMessages < ActiveRecord::Migration[8.1]
  def change
    change_column_default :messages, :read, false
  end
end
