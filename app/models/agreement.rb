class Agreement < ApplicationRecord
  has_rich_text :body
  has_one_attached :pdf
end
