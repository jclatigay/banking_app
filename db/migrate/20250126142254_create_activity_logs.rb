class CreateActivityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trackable, polymorphic: true
      t.string :action, null: false
      t.string :description, null: false
      t.json :metadata

      t.timestamps
    end
  end
end
