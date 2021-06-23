class User < ApplicationRecord
  has_many :comments

  def User.find_maximum_age
    self.maximum(:age)
  end

  def last_comment
    comments.last
  end
end
