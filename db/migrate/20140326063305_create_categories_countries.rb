# encoding: utf-8
class CreateCategoriesCountries < ActiveRecord::Migration
  def change
    create_table :categories_countries, force: true, id: false do |t|
      t.integer :category_id
      t.integer :country_id
    end
  end
end
