#Encoding: utf-8
module CompanyByRubric

  # Фитльтр по статусу компаний
  attr_accessor :filter
  # Рубрика
  attr_accessor :rubric

  def get_companies
    ReportHelper.find_companies rubric, filter
  end

  def get_filter_text
    s = case filter
          when :active
           "Активные"
          when :archived
            "Архивные"
          else
            "Все"
        end
    "Компании: #{s}"
  end

end