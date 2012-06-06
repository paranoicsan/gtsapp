# encoding: utf-8
require 'spec_helper'

describe ContractStatus do

  describe "Возврат объекта по кирилическому названию" do
    it "возвращает объект активного статуса" do
      s = "активен"
      assert ContractStatus.find_by_name(s) == ContractStatus.active, "Объект активного статуса не возвращён"
    end

    it "возвращает объект не активного статуса" do
      s = "не активен"
      assert ContractStatus.find_by_name(s) == ContractStatus.inactive, "Объект неактивного статуса не возвращён"
    end
  end

end
