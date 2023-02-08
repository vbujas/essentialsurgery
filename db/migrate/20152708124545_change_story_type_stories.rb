class ChangeStoryTypeStories < ActiveRecord::Migration
  def up
    change_column :stories, :story, :text
 
  end
end
