class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :path
      t.integer :format

      t.timestamps
    end
  end
end
