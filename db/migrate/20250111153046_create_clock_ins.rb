class CreateClockIns < ActiveRecord::Migration[7.1]
  def change
    create_table :clock_ins do |t|
      t.integer :user_id
      t.string :type

      t.timestamps
    end
  end
end
