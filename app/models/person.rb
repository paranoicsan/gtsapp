# Encoding: utf-8
class Person < ActiveRecord::Base
  belongs_to :company
  validates_presence_of :name, message: 'Введите имя'
  validates_presence_of :second_name, message: 'Введите фамилию'
  validates_numericality_of :phone, only_integer: true, allow_blank: true, message: 'Только цифры'
  validates_format_of :email, with: /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/,
      allow_blank: true, message: 'Некорректный адрес электронной почты'

  ##
  # Возвращает полное имя в формате ФИО
  # @return [String]
  def full_name
    "#{second_name} #{name} #{middle_name}".strip
  end
end