# Encoding:utf-8
class CompanyHistoryTrigger < ActiveRecord::Migration
  def up
    execute %Q{
      -- Function: update_company_editor()
      -- DROP FUNCTION update_company_editor();

      CREATE OR REPLACE FUNCTION update_company_editor()
        RETURNS trigger AS
      $BODY$BEGIN
      UPDATE companies SET editor_user_id = NEW.user_id,
      updated_at = NEW.updated_at WHERE id = NEW.company_id;
      RETURN NEW;
      END;$BODY$
        LANGUAGE plpgsql VOLATILE
        COST 100;
      ALTER FUNCTION update_company_editor()
        OWNER TO postgres;
      COMMENT ON FUNCTION update_company_editor() IS 'Обновляет редактора и время редактирования компании.';
    }
    execute %Q{
      -- Trigger: trg_update_company_editor on company_histories
      -- DROP TRIGGER trg_update_company_editor ON company_histories;

      CREATE TRIGGER trg_update_company_editor
        BEFORE INSERT OR UPDATE
        ON company_histories
        FOR EACH ROW
        EXECUTE PROCEDURE update_company_editor();
      COMMENT ON TRIGGER trg_update_company_editor ON company_histories IS 'Обновляет редактора компании и время редактирования.';

    }
  end

  def down
    execute %Q{ DROP TRIGGER trg_update_company_editor ON company_histories; }
    execute %Q{ DROP FUNCTION update_company_editor(); }
  end
end
