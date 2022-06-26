class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.string :currency_name
      t.string :currency_code
      t.decimal :average_value
      t.references :exchange_table, null: false, foreign_key: true

      t.timestamps
    end
  end
end
