class AddCompanyNeedAttentionReason < ActiveRecord::Migration
  def change
    add_column :companies, :reason_need_attention_on, :string
  end
end
                                                                           4