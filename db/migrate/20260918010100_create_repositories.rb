class CreateRepositories < ActiveRecord::Migration[8.1]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :full_name
      t.string :language
      t.string :clone_url
      t.integer :github_id, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :repositories, :github_id, unique: true
  end
end
