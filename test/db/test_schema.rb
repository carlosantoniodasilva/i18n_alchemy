ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

ActiveRecord::Base.connection.create_table :products do |t|
  t.string     :name
  t.decimal    :price
  t.integer    :quantity
  t.date       :released_at
  t.datetime   :updated_at
  t.timestamp  :last_sale_at
  t.references :supplier
  t.string     :my_precious
end

ActiveRecord::Base.connection.create_table :suppliers do |t|
  t.string     :name
  t.decimal    :a_decimal
end

ActiveRecord::Base.connection.create_table :accounts do |t|
  t.references :supplier
  t.string     :account_number
  t.decimal    :total_money
end
