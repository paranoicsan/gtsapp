#Encoding: utf-8

class User < ActiveRecord::Base
  has_many :companies
  easy_roles :roles
  acts_as_authentic do |c|
    c.validates_format_of_login_field_options :with => /\A[А-Яа-я\w\.+\-_@ ]+$/,
                                              :message => 'should use only letters, numbers, spaces, and .-_@ please.'
  end

  ##
  # Возвращает набор пользователей с ролью "Агент"
  #
  # @return [Array] Набор пользователей
  #
  def self.agents
    res = []
    self.all.each do |u|
      #noinspection RubyResolve
      if u.has_role?("agent")
        res << u
      end
    end
    res
  end

end
