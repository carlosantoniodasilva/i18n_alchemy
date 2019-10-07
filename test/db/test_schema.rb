ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :products do |t|
    t.string     :name
    t.decimal    :price, precision: 10, scale: 2
    t.integer    :quantity
    t.date       :released_at
    t.date       :released_month
    t.datetime   :updated_at
    t.timestamp  :last_sale_at
    t.references :supplier
  end

  create_table :suppliers do |t|
    t.string     :name
    t.timestamp  :created_at
  end

  create_table :accounts do |t|
    t.references :supplier
    t.string     :account_number
    t.decimal    :total_money, precision: 10, scale: 2
  end
end
