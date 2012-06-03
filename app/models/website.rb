# encoding: utf-8
require "uri"
class Website < ActiveRecord::Base
  has_many :branch_websites

  ##
  # Проверяет введённый адрес на корректность
  #
  def self.valid?(url)
    url.match(/(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix)
  end
end
