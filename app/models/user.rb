class User < ApplicationRecord
  # マイクロポストとの関連付け
  has_many :microposts, dependent: :destroy
  # 能動的関係に対して1対多の関連付け
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  # ユーザーを削除するとリレーションシップも削除
                                  dependent: :destroy
  # 受動的関係について1対多の関連付け
  has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
  # followingの関連付け
  # （「source: :followed」=「following配列のもとはfollowed idの集合である」）
  has_many :following, through: :active_relationships, source: :followed
  # followersの関連付け
  # （そのまま単数形にできるため、こちらのsourceは省略可能）
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
              uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  
  # 永続セッションのためにデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
    
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
    
  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), 
                  reset_sent_at: Time.zone.now)
    # update_attribute(:reset_digest, User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    # パスワードの再設定メールの送信時刻が、現在時刻より2時間以上前（早い）の場合
    reset_sent_at < 2.hours.ago
  end
  
  # ユーザーのステータスフィードを返す
  def feed
    # 検索条件に"following_ids（フォロー中の全ユーザーのid）"と"id（ログインユーザーのid）"
    # サブセレクト（SQL文にSQL文を含める）を行うことで動作を軽くする
    following_ids = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) 
                      OR user_id = :user_id", user_id: id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end
  
  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  # 現在のユーザーがフォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  private
    
    # メールアドレスを全小文字化
    def downcase_email
      self.email.downcase!
    end
    
    # 有効化トークンとダイジェストを作成および代入
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  
end
