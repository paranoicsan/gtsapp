# ENcoding: utf-8
class Branches::Phone < ActiveRecord::Base
  belongs_to :branch
  validates_presence_of :name

  ##
  # Возвращает отформатированный номер телефона
  # Если номер - мобильный, то вначале добавляется префикс сотового оператора
  # @param [Boolean] Флаг, что перед телефоном надо добавлять слово "Телефон" или "Телефон/факс"
  def name_formatted(use_word_prefix=false)
    s = mobile? ? "(#{mobile_refix}) #{name}" : name
    if use_word_prefix
      s = fax? ? %Q{Телефон/факс: #{s}} : %Q{Телефон: #{s}}
    end
    s
  end
end
