class CreateClassrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.references :user, index: true
      t.references :osra, index: true

      t.timestamps
    end
  end
end
