class CourseServant < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, uniqueness: { scope: :course, message: 'Servant has already been taken!' }
end
