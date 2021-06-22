class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :age

      t.timestamps
    end

    50.times do |i|
      User.create(name: ["John", "Bob", "Alisa", "Michael", "Zena", "Xena"].sample + " #{i}", age: rand(100))
    end
  end
end
