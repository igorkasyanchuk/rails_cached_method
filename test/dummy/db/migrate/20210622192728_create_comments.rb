class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.text :message

      t.timestamps
    end

    100.times do |i|
      User.all.sample.comments.create(message: "this is comment #{i}")
    end
  end
end
