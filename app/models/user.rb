class User < ApplicationRecord
  attr_accessor :subscribe
  after_create :subscribe_to_newsletter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :orders, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_one :designer_submission, dependent: :destroy
  has_one :sound_designer, dependent: :destroy
  has_one :designer_submission, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def subscribe_to_newsletter
    SubscribeToNewsletterService.new(self).call if subscribe
  end
end
