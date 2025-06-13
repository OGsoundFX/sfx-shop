class Review < ApplicationRecord
  after_create :status_pending
  belongs_to :user
  belongs_to :sfx_pack

  enum status: %i(pending accepted rejected)

  private

  def status_pending
    update(status: :pending)
  end
end
