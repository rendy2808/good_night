class CreateClockIns < ActiveRecord::Migration[7.1]
  def change
    create_table :clock_ins do |t|
      t.integer :user_id
      t.integer :clock_in_type

      t.timestamps
    end
  end
end
