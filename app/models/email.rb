#encoding: utf-8
require 'resolv'

class Email < ActiveRecord::Base
  belongs_to :branch
  validates_presence_of :name

  ##
  # Проверяет корректность
  #
  # @param [String] email Переданный на проверку адрес
  # @@return [Boolean] Истина - адрес корректен
  def valid?(email)
    false
    unless email.blank?
      re = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
      if re.match  email
        true
      else
        errors.add(:name, "Некорректный адрес электронной почты.") unless re.match email
        errors.add(:name, "Указан не существующий почтовый домен.") unless validate_email_domain(email)
        false
      end
    end
  end

  ##
  # Проверяет существование почтового домена
  #
  # @param [String] email Адрес для проверки
  # @@return [Boolean] Истина, если домен впорядке
  def validate_email_domain(email)
    begin
      domain = email.match(/\@(.+)/)[1]
      mx = []
      Resolv::DNS.open do |dns|
        mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
      end
      mx.size > 0 ? true : false
    rescue
      false
    end
  end

end
