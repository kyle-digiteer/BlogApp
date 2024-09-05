class AddUserReferenceToPost < ActiveRecord::Migration[7.1]
  def change
    add_reference :posts, :user, null: true, foreign_key: true, index: true

    change_column_null :posts, user_id, false
  end
end
