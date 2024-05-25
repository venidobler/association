module NotificationHelper
    def render_notice
      if notice.present?
        content_tag(:div, notice, class: 'alert alert-success')
      end
    end
end


  