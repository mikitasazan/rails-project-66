class CreateChecks < ActiveRecord::Migration[8.1]
  def change
    create_table :repository_checks do |t|
      t.string :aasm_state, default: "created", null: false
      t.string :commit_id
      t.text :check_log
      t.boolean :passed
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
