# サンプルユーザー
User.create!(name: "Example User",
              email: "example@railstutorial.org",
              password: "foobar",
              password_confirmation: "foobar",
              admin: true,
              activated: true,
              activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end

# 作成されたユーザーの最初の６人を明示的に呼び出す
users = User.order(:created_at).take(6)
# それぞれのユーザーにサンプルポストを50個追加
50.times do
  content = Faker::Coffee.intensifier(5)
  users.each{ |user| user.microposts.create!(content: content) }
end