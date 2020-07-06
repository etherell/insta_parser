# frozen_string_literal: true

module ApplicationHelper
  def toastr_flash(type)
    if %w[error success].include? type
      "toastr.#{type}"
    else
      'toastr.info'
    end
  end
end
