# == Schema Information
#
# Table name: branches_phones
#
#  id           :integer          not null, primary key
#  mobile_refix :string(255)
#  publishable  :boolean
#  fax          :boolean
#  director     :boolean
#  mobile       :boolean
#  description  :text
#  name         :string(255)
#  contact      :integer
#  order_num    :integer
#  branch_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_branches_phones_on_id  (id)
#

describe Branches::Phone do

  it 'фабрика корректна' do
    phone = FactoryGirl.create :phone
    phone.should be_valid
  end
  it 'нельзя создать без указания номера' do
    phone = FactoryGirl.build :phone, name: nil
    phone.should have(1).error_on(:name)
  end
  describe '#name_formatted' do
    it 'возвращает простой номер без изменений для обычного телефона' do
      phone = FactoryGirl.create :phone
      phone.name_formatted.should eq(phone.name)
    end
    it 'возвращает префикс с номером для мобильных номеров' do
      phone = FactoryGirl.create :phone, mobile: true, mobile_refix: '921'
      s = %Q{(921) #{phone.name}}
      phone.name_formatted.should eq(s)
    end
    it 'добавляет Телефон перед номером по запросу' do
      phone = FactoryGirl.create :phone
      s = %Q(Телефон: #{phone.name})
      phone.name_formatted(true).should eq(s)
    end
    it 'добавляет Телефон/факс перед номером для факса по запросу' do
      phone = FactoryGirl.create :phone, fax: true
      s = %Q(Телефон/факс: #{phone.name})
      phone.name_formatted(true).should eq(s)
    end
  end
end
