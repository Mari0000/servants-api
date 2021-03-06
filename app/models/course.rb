require 'csv'

class Course < ApplicationRecord
  include Convertable
  enum score_type: { per_course: 0, per_lecture: 1 }
  belongs_to :responsible, class_name: 'User', foreign_key: 'user_id', inverse_of: :course_responsibilities
  has_many :course_servants, dependent: :destroy
  has_many :servants, through: :course_servants, source: :user
  has_many :course_meetings, dependent: :destroy
  has_many :lectures, dependent: :destroy

  accepts_nested_attributes_for :course_servants, allow_destroy: true, reject_if: proc { |attributes| attributes['user_id'].blank? }
  accepts_nested_attributes_for :lectures, allow_destroy: true

  scope :by_year, -> (year = DateTime.now.year) { where('extract(year from created_at) = ?', year) }
  scope :latest, -> { order('created_at DESC') }

  def self.to_csv
    attributes = %w{id name no_of_lectures total_score user_id score_type}
    export_csv(attributes)
  end
end
