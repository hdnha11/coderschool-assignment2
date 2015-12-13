class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :image_url

      t.timestamps null: false
    end
    add_index :users, :email
  end
end
