module ReportHelper
  ##
  # Возвращает MIME-тип для формата
  # @param [String] Формат экспорта
  def self.mime_type(format)
    case format.downcase
      when "pdf"
        "application/pdf"
      when "rtf"
        "application/rtf"
      when "xls"
        "application/excel"
      else
        raise "Unknown format"
    end
  end

  ##
  # Возвращает компании по указанным критериям
  def self.find_companies(rubric, filter)
    case filter.to_sym
      when :active
        cs = Company.active
      when :archived
        cs = Company.archived
      else
        cs = Company.all
    end

    companies = []
    cs.find_all{ |item| item.rubrics.include?(rubric) }.each do |c|
      companies << c
    end
    companies
  end
end