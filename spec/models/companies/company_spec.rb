# == Schema Information
#
# Table name: companies_companies
#
#  id                         :integer          not null, primary key
#  title                      :string(255)
#  date_added                 :date
#  rubricator                 :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  companies_status_id        :integer
#  author_user_id             :integer
#  editor_user_id             :integer
#  companies_source_id        :integer
#  agent_id                   :integer
#  comments                   :string(255)
#  reason_deleted_on          :string(255)
#  reason_need_attention_on   :string(255)
#  reason_need_improvement_on :string(255)
#
# Indexes
#
#  index_companies_companies_on_id  (id)
#

require 'spec_helper'

module Companies

  describe Company do

    before(:each) do
      seed_statuses
    end

    let(:status_active) { Status.active }
    let(:status_archived) { Status.archived }
    let(:status_suspended) { Status.suspended }
    let(:status_deletion) { Status.queued_for_delete }
    let(:status_attention) { Status.need_attention }
    let(:status_improvements) { Status.need_improvement }


    it 'Фабрика корректна' do
      FactoryGirl.create(:company).should be_valid
    end

    it 'компания не может быть создана без названия' do
      company = FactoryGirl.build(:company, title: nil)
      company.should have(1).error_on(:title)
      company.should_not be_valid
    end

    describe 'Показывает тот или иной рубрикатор в разном виде' do

      before(:each) do
        @company = FactoryGirl.create :company
      end

      context 'должна возвращать отдельные виды рубрикатора' do

        it 'возврат социального рубрикатора' do
          @company.rubricator = 1
          assert @company.social_rubricator?, 'Должен быть только социальный рубрикатор'
        end
        it 'возврат коммерческого рубрикатора' do
          @company.rubricator = 2
          assert @company.commercial_rubricator?, 'Должен быть только коммерческий рубрикатор'
        end
        it 'возврат полного рубрикатора' do
          @company.rubricator = 3
          assert @company.full_rubricator?, 'Должен быть полный рубрикатор'
        end
      end

      context 'возвращает текстовое название рубрикатора или рубрикаторов, связанных с компанией' do
        it 'возврат имени социального рубрикатора' do
          @company.rubricator = 1
          assert @company.rubricator_name == 'Социальный', 'Социальный рубрикатор не выводится по имени'
        end
        it 'возврат имени коммерческого рубрикатора' do
          @company.rubricator = 2
          assert @company.rubricator_name == 'Коммерческий', 'Коммерческий рубрикатор не выводится по имени'
        end
        it 'возврат имени полного рубрикатора' do
          @company.rubricator = 3
          assert @company.rubricator_name == 'Полный', 'Полный рубрикатор не выводится по имени'
        end
        it 'возвращает информацию, что рубрикатор не указан, если его нет' do
          @company.rubricator = nil
          assert @company.rubricator_name == 'Не указан'
        end
      end

    end

    describe 'Создаётся с тем или иным состоянием, в зависимости от прав автора' do

      it 'статус АКТИВНА, если создаёт админ' do
        user = FactoryGirl.create :user_admin
        company = FactoryGirl.create :company, author: user, editor: user
        company.status.should eq(status_active)
      end

      it 'статус АКТИВНА, если создаёт оператор' do
        user = FactoryGirl.create :user_operator
        company = FactoryGirl.create :company, author: user, editor: user
        company.status.should eq(status_active)
      end

      it 'статус НА РАССМОТРЕНИИ, если создаёт агент' do
        company = FactoryGirl.create :company
        company.status.should eq(status_suspended)
      end

    end

    describe '#queue_for_delete' do

      let(:company) { FactoryGirl.create :company }

      context 'агент может выставить компанию на удаление' do

        it 'активная компания меняет статус на "На удаление"' do
          company.status = status_active
          expect {
            company.queue_for_delete
          }.to change(company, :status).from(status_active).to(status_deletion)
        end

        it 'архивная компания меняет статус на "На удаление"' do
          company.status = status_archived
          expect {
            company.queue_for_delete
          }.to change(company, :status).from(status_archived).to(status_deletion)
        end

        it 'компания на рассмотрении меняет статус на "На удаление"' do
          company.status = status_suspended
          expect {
            company.queue_for_delete
          }.to change(company, :status).from(status_suspended).to(status_deletion)
        end

        it 'вызывает ошибку, если не указан причина удаления' do
          company.status = status_deletion
          company.queue_for_delete
          company.should have(1).error_on(:reason_deleted_on)
        end

        it 'ставится на удаление, если указана причина' do
          company.status = status_deletion
          company.queue_for_delete 'Причина'
          company.should be_valid
        end

      end

    end

    describe '#unqueue_for_delete' do

      let(:company) { FactoryGirl.create :company }

      it 'меняет статус компании на указанный активный' do
        company.status = status_deletion
        expect {
          company.unqueue_for_delete :active
        }.to change(company, :status).from(status_deletion).to(status_active)
      end
      it 'меняет статус компании на указанный на рассмотрении' do
        company.status = status_deletion
        expect {
          company.unqueue_for_delete :suspended
        }.to change(company, :status).from(status_deletion).to(status_suspended)
      end
      it 'не меняет статус компании если архивный статус' do
        company.status = status_deletion
        expect {
          company.unqueue_for_delete :archived
        }.not_to change(company, :status).from(status_deletion).to(status_archived)
      end
      it 'не меняет статус компании если изначально не был статус на удалении' do
        company.status = status_archived
        expect {
          company.unqueue_for_delete :suspended
        }.not_to change(company, :status).from(status_archived).to(status_suspended)
      end
      it 'вызывает ошибку, если передан не существующий новый статус' do
        company.status = status_deletion
        expect {
          company.unqueue_for_delete :unknown
        }.to raise_error
      end
    end

    describe '#queued_for_deletion?' do
      let(:company) { FactoryGirl.create :company }

      it 'возвращает истину, если компания помечена на удаление' do
        company.status = status_deletion
        company.queued_for_deletion?.should eq(true)
      end
      it 'возвращает ложь, если компания не помечена на удаление' do
        company.queued_for_deletion?.should_not eq(true)
      end
    end

    describe '.queued_for_delete' do
      it 'возвращает компании на удалении' do
        company = FactoryGirl.create :company
        company.queue_for_delete Faker::Lorem.sentence
        Company.queued_for_delete.should eq([company])
      end
    end

    describe '#need_attention?' do
      let(:company) { FactoryGirl.create :company }
      it 'возвращает истину, если компания с указанным статусом' do
        company.status = status_attention
        company.need_attention?.should be_true
      end
      it 'возвращает ложь, если компания с любым другим статусом' do
        company.need_attention?.should be_false
      end
    end

    describe '#need_improvement?' do
      let(:company) { FactoryGirl.create :company }

      it 'возвращает истину, если компания с указанным статусом' do
        company.status = status_improvements
        company.need_improvement?.should be_true
      end
      it 'возвращает ложь, если компания с любым другим статусом' do
        company.need_improvement?.should be_false
      end
    end

    describe '.need_attention' do
      it 'возвращает компании, требующие внимания' do
        company = FactoryGirl.create :company, reason_need_attention_on: Faker::Lorem.sentence
        company.status = status_attention
        company.save
        Company.need_attention.should eq([company])
      end
    end

    describe '.need_improvement' do
      it 'возвращает компании на доработке' do
        company = FactoryGirl.create :company,
                                     reason_need_improvement_on: Faker::Lorem.sentence
        company.status = status_improvements
        company.save
        Company.need_improvement.should eq([company])
      end
    end

    describe '.need_improvement_by_user' do
      it 'возвращает компании на доработке для агента-автора' do
        author = FactoryGirl.create(:user)
        company = FactoryGirl.create :company,
                                     reason_need_improvement_on: Faker::Lorem.sentence,
                                     author: author
        company.status = status_improvements
        company.save
        Company.need_improvement_by_user(author.id).should eq([company])
      end
    end

    describe '#archived?' do
      let(:company) { FactoryGirl.create :company }
      it 'возвращает истину, если компания с указанным статусом' do
        company.status = status_archived
        company.archived?.should be_true
      end
      it 'возвращает ложь, если компания с любым другим статусом' do
        company.archived?.should be_false
      end
    end

    describe '.activate' do

      before(:each) do
        @company = FactoryGirl.create :company_suspended
        @company.reason_need_attention_on = Faker::Lorem.sentences.join
        @company.reason_deleted_on = Faker::Lorem.sentences.join
        @company.reason_need_improvement_on = Faker::Lorem.sentences.join
      end

      it 'меняет статус компании на активный' do
        Company.activate @company.id
        Company.find(@company.id).status.should eq(status_active)
      end
      it 'Сбрасывает причину запроса внимания' do
        Company.activate(@company.id)
        Company.find(@company.id).reason_need_attention_on.should be_nil
      end
      it 'Сбрасывает причину удаления' do
        Company.activate(@company.id)
        Company.find(@company.id).reason_deleted_on.should be_nil
      end
      it 'Сбрасывает причину отправки на доработку' do
        Company.activate(@company.id)
        Company.find(@company.id).reason_need_improvement_on.should be_nil
      end
    end

    describe '#archive' do
      before(:each) do
        @company = FactoryGirl.create :company, status: status_active
      end
      it 'меняет статус компании на архивный' do
        @company.archive
        @company.status.should eq(status_archived)
      end
      it 'Сбрасывает причину запроса внимания' do
        @company.reason_need_attention_on = Faker::Lorem.sentences.join
        @company.archive
        @company.reason_need_attention_on.should be_nil
      end
      it 'Сбрасывает причину удаления' do
        @company.reason_deleted_on = Faker::Lorem.sentences.join
        @company.archive
        @company.reason_deleted_on.should be_nil
      end
      it 'Сбрасывает причину отправки на доработку' do
        @company.reason_need_improvement_on = Faker::Lorem.sentences.join
        @company.archive
        @company.reason_need_improvement_on.should be_nil
      end
    end

    describe '#can_be_activated_by_agent?' do
      it 'возвращает истину, если текущий статус - архивный' do
        company = FactoryGirl.create :company
        company.archive
        company.can_be_activated_by_agent?.should be_true
      end
    end

    describe '#main_branch' do
      it 'возвращает головной филиал' do
        branch = FactoryGirl.create :branch
        branch.company.main_branch.should eq(branch)
      end
    end


    describe '.by_street' do
      def create_company(status = status_active)
        company = FactoryGirl.create :company
        company.status = status
        company.save
        b = FactoryGirl.create :branch, company_id: company.id
        FactoryGirl.create :address, branch_id: b.id, street_id: @street.id, city_id: @street.city.id
        company
      end

      before(:each) do
        @street = FactoryGirl.create :street
      end
      it 'возвращает список компаний на указанной улице' do
        company = create_company
        params = {
            filter: :active,
            rubricator_filter: 1
        }
        Company.by_street(@street.id, params).should eq([company])
      end
      it 'возвращает только активные компании, если указан фильтр' do
        company = create_company
        params = {
            filter: :active,
            rubricator_filter: 1
        }
        Company.by_street(@street.id, params).should eq([company])
      end
      it 'возвращает только архивные компании, если указан фильтр' do
        company = create_company status_archived
        params = {
            filter: :archived,
            rubricator_filter: 1
        }
        Company.by_street(@street.id, params).should eq([company])
      end
      it 'возвращает все компании, если указан фильтр' do
        companies = []
        2.times { companies << create_company }
        params = {
            filter: :all,
            rubricator_filter: 1
        }
        Company.by_street(@street.id, params).should eq(companies)
      end
    end
  end

end
