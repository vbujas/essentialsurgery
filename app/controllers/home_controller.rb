class HomeController < ApplicationController

     # before_filter :redirect, except: [:check_pwd, :docheckpassword] 
      layout "application", only: [:index, :drdensity, :drgender]
      layout "password", only: [:check_pwd]


  def redirect
 
   if session['authorised'] !=true then
     redirect_to action: 'check_pwd' 
   end
  end  

  def docheckpassword
   pass = 'globalsurgery15'
  postpass = params[:pwd]
  if pass == postpass then
          session['authorised'] = true;
            render :status=>200, :json=>{ :message=>'ok'}       
      else
            render :status=>200, :json=>{ :message=>'error'}          
      end

  end

  def check_pwd
     if session['authorised'] !=true then
      render :template => "home/check_pwd" 
    else
      redirect_to action: 'drdensity' 
     
    end
           
  end

  def index
  	  @stories = Story.all.order( 'stories.order ASC' )
  	 # sql = "SELECT organisations.id, organisations.name, cities.name, countries.name, organisations.training, organisations.latitude, organisations.longitude FROM organisations, countries, cities WHERE cities.id = organisations.city_id AND cities.country_id = countries.id"
       sql = "SELECT * FROM ngos WHERE internal_yn = 'Y'"
      @organisations = ActiveRecord::Base.connection.execute(sql);   
      @bug = Bug.new
      
  end
    def drdensity
  	  @stories = Story.all.order( 'stories.order ASC' )
      @alldistricts = District.all
  	 # sql = "SELECT organisations.id, organisations.name, cities.name, countries.name, organisations.training, organisations.latitude, organisations.longitude FROM organisations, countries, cities WHERE cities.id = organisations.city_id AND cities.country_id = countries.id"
       sql = "SELECT * FROM ngos WHERE internal_yn = 'Y'"
     
      sqlngos = "SELECT * FROM ngos WHERE internal_yn = 'Y'"
      @organisations = ActiveRecord::Base.connection.execute(sql); 
      @ngos =  ActiveRecord::Base.connection.execute(sqlngos); 
      @bug = Bug.new
  end
    def drgender
  	  @stories = Story.all.order( 'stories.order ASC' )
  	#  sql = "SELECT organisations.id, organisations.name, cities.name, countries.name, organisations.training, organisations.latitude, organisations.longitude FROM organisations, countries, cities WHERE cities.id = organisations.city_id AND cities.country_id = countries.id"
       sql = "SELECT * FROM ngos WHERE internal_yn = 'Y'"
     
      sqlngos = "SELECT * FROM ngos WHERE internal_yn = 'Y'"
      @ngos =  ActiveRecord::Base.connection.execute(sqlngos); 
      @organisations = ActiveRecord::Base.connection.execute(sql);   
      @bug = Bug.new
  end
   def about
  end
   def privacy
  end
   def contact
  end
end
 