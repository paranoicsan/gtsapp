# == Schema Information
#
# Table name: branches_branches
#
#  id           :integer          not null, primary key
#  form_type_id :integer
#  fact_name    :string(255)
#  legel_name   :string(255)
#  company_id   :integer
#  comments     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_main      :boolean
#
# Indexes
#
#  index_branches_branches_on_id  (id)
#

describe Branches::Branch do

  let(:branch) { FactoryGirl.create :branch }

  it 'фабрика корректна' do
    b = FactoryGirl.create :branch
    b.should be_valid
  end

  context 'создание' do
    before(:each) do
      @branch = FactoryGirl.create :branch
    end
    it 'первый филиал для компании всегда головной' do
      @branch.is_main.should be_true
    end
    it 'остальные всегда НЕ головные' do
      b = FactoryGirl.create :branch, company: @branch.company
      b.is_main.should be_false
    end
  end

  context 'не может быть создан без' do
    it 'фактического названия' do
      @field = :fact_name
    end
    it 'юридического названия' do
      @field = :legel_name
    end
    after(:each) do
      branch = FactoryGirl.build :branch, {@field.to_sym => ''}
      branch.should have(1).error_on(@field)
    end
  end

  describe '#make_main' do
    before(:each) do
      @branch = FactoryGirl.create :branch
    end
    it 'делает главным указанный филиал' do
      @branch.update_attributes is_main: false
      @branch.is_main.should be_false
      @branch.make_main
      @branch.reload.is_main.should be_true
    end
    it 'все остальные делает НЕ главными' do
      @branch.is_main.should be_true
      company_id = @branch.company.id
      FactoryGirl.create_list :branch, 5, company_id: company_id
      b = FactoryGirl.create :branch, company_id: company_id

      # делаем головным
      b.make_main

      Branches::Branch.by_company(company_id).each do |branch|
        val = branch.id == b.id
        branch.is_main.should == val
      end
    end
  end

  describe '#all_emails_str' do
    it 'возвращает все адреса через запятую' do
      3.times do
        branch.emails << FactoryGirl.create(:email, branch_id: branch.id)
      end
      s = ''
      branch.emails.each { |e| s = "#{s}#{e.name}, " }
      s = s.gsub(/, $/, '')
      branch.all_emails_str.should eq(s)
    end
  end

  describe '#all_websites_str' do
    it 'возвращает все сайты через запятую' do
      3.times do
        branch.websites << FactoryGirl.create(:website)
      end
      s = ''
      branch.websites.each { |w| s = "#{s}#{w.name}, " }
      s = s.gsub(/, $/, '')
      branch.all_websites_str.should eq(s)
    end
  end

  describe '#phones_by_order' do
    def create_phone(branch_id)
      FactoryGirl.create :phone, branch_id: branch_id
    end

    it 'возвращает массив по порядку индекса отображения' do
      branch = FactoryGirl.create :branch
      p1 = create_phone(branch.id)
      p2 = create_phone(branch.id)
      branch.phones_by_order.should eq([p1, p2])
    end
  end

  describe '#next_phone_order_index' do
    it 'возвращает единицу для первого телефона' do
      branch.next_phone_order_index.should eq(1)
    end
    it 'возвращает следующий порядковый индекс отображения для телефонов' do
      FactoryGirl.create :phone, branch_id: branch.id
      branch.next_phone_order_index.should eq(2)
    end
  end

  describe '#update_phone_order' do
    PHONE_CNT = 5
    before(:each) do
      @b = branch
      PHONE_CNT.times do |i|
        FactoryGirl.create :phone, branch_id: @b.id, order_num: i+1
      end
      @b.phones.sort!{ |a, b| a.id <=> b.id }
    end

    def delete_and_update(index)
      @b.phones[index].destroy
      @b.update_phone_order
    end

    it 'обновляет список телефонов при удалении первого' do
      delete_and_update(0)
      @b.phones[0].order_num.should eq(1)
    end
    it 'обновляет список телефонов при удалении из середины' do
      delete_and_update(PHONE_CNT-3)
      @b.phones.count.times do |i|
        @b.phones[i].order_num.should eq(i+1)
      end
    end
    it 'ничего не меняется при удалении последнего' do
      delete_and_update(PHONE_CNT-1)
      @b.phones[PHONE_CNT-2].order_num.should eq(PHONE_CNT-1)
    end
    it 'обновляет список телефонов при добавлении нового' do
      @b.phones << FactoryGirl.create(:phone, branch_id: @b.id, order_num: 3)
      @b.update_phone_order(true)
      @b.phones.count.times do |i|
        @b.phones[i].order_num.should eq(i+1)
      end
    end
    it 'обновляет список телефонов при изменении существующего' do
      moved_phone = @b.phones[3]
      @b.phones[1].update_attribute 'order_num', 4
      @b.update_phone_order
      moved_phone.reload
      moved_phone.order_num.should eq(3)
    end
  end
end
