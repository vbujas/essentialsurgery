class NgosController < ApplicationController
require 'csv'
 respond_to :html, :json
def ngospercountry
sql = "SELECT count( ngos_engagement.organization_id) , ngos_engagement.country_code from ngos_engagement, ngos WHERE ngos.id = ngos_engagement.organization_id AND ngos.internal_yn = 'Y' GROUP BY  ngos_engagement.country_code"
file = File.read("public/COUNTRIES2.geojson")
geojsonngos = ActiveSupport::JSON.decode(file.force_encoding("ISO-8859-1").encode("UTF-8"))

@ngosbycountries = ActiveRecord::Base.connection.execute(sql);
 features = Array.new

 @ngosbycountries.each_with_index do |country, index|
   row = Hash.new 
   feature = Hash.new
   feature['type'] = 'feature'
    row['ne_10m_adm'] =  country[1]    
    row['ngos'] =   country[0]
    row['ADM_0'] =  country[1]
   
   
  geojsonngos["features"].each do |cnt|
   if country[1] == cnt['properties']['ISO_A3'] then
   	cnt['properties']['ngos'] = country[0]
   #	puts  cnt['properties']
 #  else
 # 	cnt['properties']['ngos'] = 0

  end

  feature['properties'] = row
end

   features.push(feature)

 end
 #geojsonngos['features'] = features;
 #puts geojsonngos
new_json_data = geojsonngos.to_json
file = File.open("public/COUNTRIESNGOS.geojson", "w")  { |file| file.write(new_json_data) }

render :status=>200, :json=>{ :message=>'ok'} 
end

def getngosforcountry

query = params[:country_code] || '';  
sql = "SELECT ngos.id, ngos.organization_name, ngos.website  country_code from ngos, ngos_engagement WHERE ngos.id = ngos_engagement.organization_id AND ngos_engagement.country_code ='" + query + "' AND ngos.internal_yn = 'Y'";
connect = ActiveRecord::Base.connection();
@ngosbycountries =  connect.execute(ActiveRecord::Base.send(:sanitize_sql_array, sql))
#st = ActiveRecord::Base.connection.raw_connection.prepare()
#@ngosbycountries = st.execute(query);
  
render :status=>200, :json=>@ngosbycountries.to_json 
end

def populaterawtable

 file = File.read("public/INTERNAL_NGOS_COUNTRIES.json")
geojsonngos = ActiveSupport::JSON.decode(file.force_encoding("ISO-8859-1").encode("UTF-8"))
 geojsonngos.each_with_index do |ngo, index|
   
   ngoid = ngo['id']
   country = ngo['country']
   
  countriesarray = country.split(',') 
  connect = ActiveRecord::Base.connection();
    
    countriesarray.each_with_index do |cntry, index|
    sql = "INSERT INTO countries_raw ( ngo_id, raw_country, raw_country_code) VALUES ("+ngoid.to_s+", '"+cntry +"' , 'NON')";
    ok =  connect.execute(ActiveRecord::Base.send(:sanitize_sql_array, sql))
    puts 'NGO >>>' + ngoid.to_s + " COUNTRY >> " + cntry + " OK>>" + ok.to_s
    end
  end

render :status=>200, :json=>geojsonngos.to_json 
end


def getngodetails
 
puts 'ORGID IS >>>>>' + params[:id].to_s

@ngo = Ngo.find(params[:id])

respond_to do |format|
   format.json { render :json => @ngo }
   end
 
  end


def findcountrycode

  connect = ActiveRecord::Base.connection();
  sql = "SELECT * FROM countries_raw";
  rawcountries =  connect.execute(ActiveRecord::Base.send(:sanitize_sql_array, sql))
  
  rawcountries.each_with_index do |cntry, index|
  
  sql = "SELECT * FROM countries_codes WHERE TRIM(UPPER(country_name))  LIKE TRIM(UPPER('"+cntry[2]+"'))";
  ccode =  connect.execute(ActiveRecord::Base.send(:sanitize_sql_array, sql))
  
      ccd = ccode.first
      if ccd then    
      puts "CCD IS >>>>>>" + ccd[0] 
      sql = "UPDATE countries_raw SET raw_country_code = '"+  ccd[0] +"' WHERE id=" + cntry[0].to_s
      ccode =  connect.execute(ActiveRecord::Base.send(:sanitize_sql_array, sql))
     end

  end
  render :status=>200, :json=>{'message': 'ok'} 
end


  def update
  end

  def edit
  end
 
  def set_ngo
    @specialty = Ngo.find(params[:id])
  end

  def ngo_params
    params.require(:ngo).permit(:id, :name)
  end

end
