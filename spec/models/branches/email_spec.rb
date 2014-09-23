#encoding: utf-8
require 'spec_helper'

describe Email do

  describe "существует проверка на корректность введённого адреса" do
    it "возвращает истину при корректном адресе" do
      s = 'test@test.com'
      assert Email.valid?(s) == true, 'Проверка не работает 0'
    end
    it "возвращает ложь при ошибочном адресе" do
      s = 'test@test'
      assert Email.valid?(s) == false, 'Проверка не работает 1'
      s = 'testtest.com'
      assert Email.valid?(s) == false, 'Проверка не работает 2'
      s = 'testtest'
      assert Email.valid?(s) == false, 'Проверка не работает 3'
    end
  end

end
