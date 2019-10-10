# サンプルユーザー
User.create!(name:                   "Example User",
              email:                 "example@railstutorial.org",
              password:              "foobar",
              password_confirmation: "foobar",
              admin:                 true,
              activated:             true,
              activated_at:          Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:                   name,
                email:                 email,
                password:              password,
                password_confirmation: password,
                activated:             true,
                activated_at:          Time.zone.now)
end

# サンプルマイクロポスト
# 作成されたユーザーの最初の６人を明示的に呼び出す
users = User.order(:created_at).take(6)
# それぞれのユーザーにサンプルポストを50個追加
50.times do
  content = Faker::Lorem.sentence(5)
  users.each{ |user| user.microposts.create!(content: content) }
end

# サンプルのリレーションシップ
users = User.all
user = users.first
# 最初のユーザーがユーザー3からユーザー51までをフォロー
following = users[2..50]
# ユーザー4からユーザー41が最初のユーザーをフォロー
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }