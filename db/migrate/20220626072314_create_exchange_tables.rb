class CreateExchangeTables < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_tables do |t|
      t.integer :tab_type
      t.string :published_at

      t.timestamps
    end
  end
end
