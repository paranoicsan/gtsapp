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
end