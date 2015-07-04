class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :mobile_no
      t.string :friend_mobile_no
      t.datetime :visited_time
      t.boolean :visited_flag

      t.timestamps null: false
    end
  end
end
