class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    # user_idに関連するマイクロポストを取り出しやすくする
    add_index :microposts, [:user_id, :created_at]
  end
end
