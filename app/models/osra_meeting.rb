require 'csv'

class OsraMeeting < ApplicationRecord
  include Convertable
  REPEAT_TYPES = { 'once' => 0, 'daily' => 1, 'weekly' => 7, 'monthly' => 30, 'yearly' => 365 }.freeze

  belongs_to :osra
  has_many :events, as: :eventable, dependent: :destroy
  has_many :osra_meeting_servants, dependent: :destroy
  has_many :osra_servants, through: :osra_meeting_servants

  validates :name,
    :start_date,
    :end_date,
    :from,
    :to,
    :repeat,
    presence: true
  validates :repeat, inclusion: { in: REPEAT_TYPES.keys }

  after_create_commit :create_events

  scope :by_year, -> (year = DateTime.now.year) { where('extract(year from created_at) = ?', year) }
  scope :by_date, -> (date) { where('DATE(start_date) = ?', date) }
  scope :latest, -> { order('created_at DESC') }

  private

  def create_events
    if repeat == 'once'
      events.create(date: start_date)
    else
      (start_date..end_date).step(REPEAT_TYPES[repeat]).each do |date|
        events.create(date: date)
      end
    end
  end

  def self.to_csv
    attributes = %w{id osra_id name start_date end_date from to repeat }
    export_csv(attributes)
  end
end
