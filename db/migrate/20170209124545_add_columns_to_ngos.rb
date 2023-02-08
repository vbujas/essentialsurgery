class AddColumnsToNgos < ActiveRecord::Migration
  def change

    add_column :ngos, :hq_address, :text
    add_column :ngos, :name ,:text
    add_column :ngos, :mission , :text
    add_column :ngos, :ngotype , :text
    add_column :ngos, :specialty , :text
    add_column :ngos, :education_yn , :string, :limit => 1    
    add_column :ngos, :training_yn , :string, :limit => 1 
    add_column :ngos, :medsupply_yn , :string, :limit => 1 
    add_column :ngos, :technology_yn , :string, :limit => 1 
    add_column :ngos, :anaesthesia_focused , :string, :limit => 1 
    add_column :ngos, :obstetrics_focused , :string, :limit => 1 
    add_column :ngos, :internal_yn , :string, :limit => 1, :default => 'N'  
    

  end
end
