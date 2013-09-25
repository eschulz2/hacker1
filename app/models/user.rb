class User < ActiveRecord::Base
  has_many :comments
  has_many :posts
  has_many :commented_posts, through: :comments, source: :post
  validates_presence_of :password, :username
  validates_uniqueness_of :username

  include BCrypt

  def password=(new_password)
    return nil if new_password == ""
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  def password
    return nil unless password_digest
    @password ||= Password.new(password_digest)
  end

  def self.authenticate(args)
    user = User.find_by_username(args[:username])
    return user if user && (user.password == args[:password])
    nil
  end

end
