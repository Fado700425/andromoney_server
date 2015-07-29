class UpdateUtf8TextToUtf8mb4 < ActiveRecord::Migration
  def change
    execute "ALTER TABLE record_table charset=utf8mb4, MODIFY COLUMN remark text CHARACTER SET utf8mb4  COLLATE utf8mb4_unicode_ci;"
    execute "ALTER TABLE category_table charset=utf8mb4, MODIFY COLUMN category varchar(255) CHARACTER SET utf8mb4  COLLATE utf8mb4_unicode_ci;"
    execute "ALTER TABLE payment_table charset=utf8mb4, MODIFY COLUMN payment_name VARCHAR(255) CHARACTER SET utf8mb4,MODIFY COLUMN remark VARCHAR(255) CHARACTER SET utf8mb4  COLLATE utf8mb4_unicode_ci;"
    execute "ALTER TABLE project_table charset=utf8mb4, MODIFY COLUMN project_name varchar(255) CHARACTER SET utf8mb4  COLLATE utf8mb4_unicode_ci;"
    execute "ALTER TABLE subcategory_table charset=utf8mb4, MODIFY COLUMN subcategory varchar(255) CHARACTER SET utf8mb4  COLLATE utf8mb4_unicode_ci;"
    execute "ALTER TABLE payee_table charset=utf8mb4, MODIFY COLUMN payee_name varchar(255) CHARACTER SET utf8mb4  COLLATE utf8mb4_unicode_ci;"
    execute "ALTER DATABASE andromoney CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;"
  end
end
