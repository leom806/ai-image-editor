# frozen_string_literal: true

#
# Represents an image in the application
#
class Image < ApplicationRecord
  self.inheritance_column = nil

  validates :prompt, presence: true
  validates :url,    presence: true

  scope :sorted, -> { order(id: :desc) }

  enum type: {
    regular: 0,
    upscale: 1,
    edit: 2,
  }
end
