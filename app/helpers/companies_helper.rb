module CompaniesHelper
  def status_span(status)
    case status
      when Status.active
        val = 'label-success'
      when Status.suspended
        val = ''
      when Status.archived
        val = ''
      when Status.queued_for_delete
        val = 'label-important'
      when Status.need_attention
        val = 'label-warning'
      when Status.need_improvement
        val = 'label-info'
      when Status.second_suspend
        val = ''
      else
        val = 'Неизвестный статус'
    end
    content_tag :span, status.name, class: "label #{val}"
  end
end
