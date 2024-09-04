class AddColumnsToPost < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :is_active, :boolean, default: true
    #Ex:- :default =>''
    add_column :posts, :is_featured, :boolean, default: false
    add_column :posts, :publish_date, :date, default: Date.today
  end
end
