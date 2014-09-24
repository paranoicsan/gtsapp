require 'spec_helper'

module Contracts

  describe Contracts::Status do

    describe 'Возврат объекта по кирилическому названию' do

      before(:all) do
        seed_contract_statuses
      end

      it 'возвращает объект активного статуса' do
        Status.active.name.should eq(Status::ACTIVE)
      end

      it 'возвращает объект не активного статуса' do
        Status.inactive.name.should eq(Status::INACTIVE)
      end

      it 'возвращает объект статуса на рассмотрении' do
        Status.pending.name.should eq(Status::PENDING)
      end
    end

  end

end