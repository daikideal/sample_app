class Relationship < ApplicationRecord
  # リレーションシップ/フォロワーに対して関連付け
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # Relationshipモデルに対するバリデーション（省略可）
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
