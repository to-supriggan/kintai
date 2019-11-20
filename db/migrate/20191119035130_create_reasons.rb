class CreateReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :reasons do |t|
      t.string :reason, null: false
      t.references :user, forgeign_key: true
      t.references :worktime, foreign_key: true

      t.timestamps
    end
  end
end
