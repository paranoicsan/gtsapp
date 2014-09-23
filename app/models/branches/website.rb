# encoding: utf-8
require 'uri'
class Branches::Website < ActiveRecord::Base

  has_and_belongs_to_many :branches, join_table: 'branches_websites_join'

  ##
  # Проверяет введённый адрес на корректность
  #
  # @param [String] url Переданный на проверку адрес
  def self.valid?(url)
    re = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
    re_cyr = /^(([0-9а-яА-ЯёЁ]*[^\.])\.рф)$/
    url.match(re) || url.match(re_cyr)
  end
end