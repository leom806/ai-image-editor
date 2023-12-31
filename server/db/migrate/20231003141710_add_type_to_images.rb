# frozen_string_literal: true

class AddTypeToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :type, :integer, null: false, default: 0
  end
end
