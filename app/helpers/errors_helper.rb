# frozen_string_literal: true

module ErrorsHelper
  # Rendering an error inside the field
  #
  # @param html_tag [ActiveSupport::SafeBuffer]
  # @param instance [ActionView::Helpers::Tags::Base]
  def field_error_helper(html_tag, instance)
    return html_tag if instance.is_a?(ActionView::Helpers::Tags::Label) # Don't wrap labels

    error_messages = instance.error_message
    content_tag(:div, html_tag + content_tag(:div, error_messages.join('; '), class: 'error-text'),
                class: 'field-with-errors')
  end
end
