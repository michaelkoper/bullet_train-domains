class CreateDomains < ActiveRecord::Migration[7.2]
  def change
    create_table :domains do |t|
      t.references :team, null: false, foreign_key: true
      t.string :address
      t.string :status
      t.string :external_hostname_id
      t.string :txt_verification_name
      t.string :txt_verification_value

      t.timestamps
    end

    add_index :domains, :address, unique: true
    add_index :domains, :external_hostname_id
  end
end
