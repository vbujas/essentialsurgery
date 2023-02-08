class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story, only: [:show, :edit, :update, :destroy]  
  respond_to :html, :json
  layout 'admin_panel'
  def index
    if current_user.admin?
      @stories = Story.paginate(:page => params[:page], :per_page => 10)   
    end
  end

  def show
    respond_with(@story)
  end

  def new
    @story = Story.new
    respond_with(@story)
  end

  def edit
      @story = Story.find(params[:id])
  end

  def create
     respond_to do |format|
    @story = Story.new(story_params)
  if  @story.save
     format.html { redirect_to action:"index", notice: 'Story was succesfully created.' }
    
    else 
     format.html { redirect_to action:"index", notice: 'Story was not created.' }
    end
   end
  end

  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to :back, notice: 'Story was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @story.destroy
    respond_with(@story)
  end

  private
    def set_story
      @story = Story.find(params[:id])
    end

    def story_params
      params.require(:story).permit(:title, :story, :iconclass, :order)
    end
end
