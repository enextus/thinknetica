# frozen_string_literal: true

# module Validation
module Validation
  def valid?
    validate!
    true
  rescue
    false
  end
end
