class OsraServant < ApplicationRecord
  belongs_to :osra
  belongs_to :user

  validates :user, uniqueness: { scope: :osra }
end
