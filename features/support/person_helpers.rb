# encoding: utf-8
require "unicode_utils/downcase"

module PersonHelpers

  def person_attributes
    FactoryGirl.attributes_for :person
  end

  def person_row(attrs)
    "|#{attrs[:position]}|#{attrs[:second_name]}|#{attrs[:name]}|#{attrs[:middle_name]}|#{attrs[:phone]}|#{attrs[:email]}|"
  end

  def create_person(company)
    FactoryGirl.create :person, company_id: company.id
  end

  def attr_id_by_name(name)
    case UnicodeUtils.downcase(name)
      when "имя"
        elem_id = "person_name"
      when "фамилия"
        elem_id = "person_second_name"
      else
        raise "неизвестный параметр"
    end
    elem_id
  end

  ##
  # Возвращет идентификатор группы полей
  def group_attr_id_by_name(name)
    case UnicodeUtils.downcase(name)
      when "имя"
        elem_id = "person_name_group"
      when "фамилия"
        elem_id = "person_second_name_group"
      when "email"
        elem_id = "person_email_group"
      else
        raise "неизвестный параметр"
    end
    elem_id
  end

end

World(PersonHelpers)