#Encoding: utf-8
module CompaniesHelper
  def status_span(status)
    case status
      when CompanyStatus.active
        val = 'label-success'
      when CompanyStatus.suspended
        val = ''
      when CompanyStatus.archived
        val = ''
      when CompanyStatus.queued_for_delete
        val = 'label-important'
      when CompanyStatus.need_attention
        val = 'label-warning'
      when CompanyStatus.need_improvement
        val = 'label-info'
      when CompanyStatus.second_suspend
        val = ''
      else
        val = 'Неизвестный статус'
    end
    content_tag :span, status.name, class: "label #{val}"
  end
end
