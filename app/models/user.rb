class User < ActiveRecord::Base
  has_many :companies
  easy_roles :roles
  acts_as_authentic

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
