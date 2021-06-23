class Comment < ApplicationRecord
  belongs_to :user

  def Comment.find_maximum_age
    'n/a'
  end
end
