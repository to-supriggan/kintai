class CreateWorktimes < ActiveRecord::Migration[5.2]
  def change
    create_table :worktimes do |t|
      t.string :year
      t.string :month
      t.string :day
      t.time :attendance
      t.time :retirement
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
