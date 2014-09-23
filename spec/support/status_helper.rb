module StatusHelper

  #
  # Создаёт набор статусов компаний
  #
  def seed_statuses
    FactoryGirl.create :company_status_active
    FactoryGirl.create :company_status_suspended
    FactoryGirl.create :company_status_second_suspend
    FactoryGirl.create :company_status_archived
    FactoryGirl.create :company_status_on_deletion
    FactoryGirl.create :company_status_need_attention
    FactoryGirl.create :company_status_need_improvement
  end

end