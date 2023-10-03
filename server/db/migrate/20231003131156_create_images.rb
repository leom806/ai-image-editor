class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :url, null: false
      t.string :prompt, null: false

      t.timestamps
    end
  end
end
