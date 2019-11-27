class CreateReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :reasons do |t|
      t.string :year
      t.string :month
      t.string :day
      t.string :reason, null: false
      t.references :user, forgeign_key: true

      t.timestamps
    end
  end
end
