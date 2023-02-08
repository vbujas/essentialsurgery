class ReportsController < ApplicationController
require 'csv'
require 'browser'
  def csvdrdensity
     sql = "SELECT cities.`name` AS name, cities.`longitude` AS longitude, cities.`latitude` AS latitude, count(doctors.`id`) AS nodoctors, countries.`name` AS country FROM doctors, cities, countries WHERE doctors.`city_id` = cities.`id` AND doctors.`country_id` = countries.`id` AND cities.longitude <> '' GROUP BY cities.`name`"
  	# @cities = Doctor.joins(:city)where.not(longitude: "" ).group()
  @res =	ActiveRecord::Base.connection.execute(sql);
     csv_string = CSV.generate do |csv|
         csv << ["city", "longitude","latitude", "nodoctors", "country"]
         @res.each do |city|
           csv << [city[0],  city[2], city[1], city[3], city[4]]
         end
  end 
   send_data csv_string,
   :type => 'text/csv; charset=iso-8859-1; header=present',
   :disposition => "attachment; filename=cities.csv" 
end 

    def csvdrbycountry
     sql = "SELECT countries.`name` AS name, countries.`longitude` AS longitude, countries.`latitude` AS latitude, count(doctors.`id`) AS nodoctors, countries.`population` FROM doctors, countries WHERE doctors.`country_id` = countries.`id` GROUP BY countries.`name`"
  	# @cities = Doctor.joins(:city)where.not(longitude: "" ).group()
     @res =	ActiveRecord::Base.connection.execute(sql);
     csv_country = CSV.generate do |csv|
         csv << ["country", "longitude","latitude",  "nodoctors", "avg"]
         @res.each do |city|
         	avg = city[3].to_f / (city[4].to_f / 100000) 
           csv << [city[0],  city[2], city[1], city[3], avg.round(3) ]
         end
    end

     send_data csv_country,
   :type => 'text/csv; charset=iso-8859-1; header=present',
   :disposition => "attachment; filename=cities.csv" 
end 

    def geojsondrbygender
     sql = "SELECT  countries.`name`, countries.`latitude`, countries.`longitude`,sum(IF(doctors.`gender` = 'Male', 1, 0))as male, sum(IF(doctors.`gender` = 'Female', 1, 0)) as female FROM doctors, countries WHERE doctors.`country_id` = countries.`id` GROUP BY countries.`name`"
  	# @cities = Doctor.joins(:city)where.not(longitude: "" ).group()
    @res =	ActiveRecord::Base.connection.execute(sql);
    file = File.read("public/COSECA_COUNTRIES.geojson")
    geojson = ActiveSupport::JSON.decode(file)

       geojson['features'].each do |country|
       country['properties'].delete('pctdoctors')
       country['properties'].delete('nodoctors')
       country['properties'].delete('name_forma')
       country['properties'].delete('terr_')
       country['properties'].delete('postal')

          @res.each do |countrygender|
          if countrygender[0] == country['properties']['name'] then

         	sumdocs = countrygender[3] + countrygender[4]
         	pctmale = countrygender[3].to_f * 100 / sumdocs
         	pctfemale  = countrygender[4].to_f * 100 / sumdocs
          country['properties']['sumdocs'] = sumdocs.to_f
          country['properties']['female'] = countrygender[4].to_f
          country['properties']['male'] = countrygender[3].to_f
          country['properties']['pctfemale'] = pctfemale.round(1)
          country['properties']['pctmale'] = pctmale.round(2)
         end
         end
  end
new_json_data = geojson.to_json
file = File.open("public/COSECA_COUNTRIES.geojson", "w")  { |file| file.write(new_json_data) }
render :status=>200, :json=>{ :message=>'ok'}    
end 

    def csvalldocs
     sql = "SELECT `doctors`.`first_name`, doctors.`last_name`, `cities`.`name` AS city, cities.`latitude`,`cities`.`longitude`, `countries`.`name` AS country, `organisations`.`name` AS organisation FROM `doctors`, `cities`, `countries`, `organisations` WHERE `doctors`.`city_id` = `cities`.`id` AND `doctors`.`country_id` = `countries`.`id` AND `doctors`.`organisation_id` = `organisations`.`id`"
    # @cities = Doctor.joins(:city)where.not(longitude: "" ).group()
  @res =  ActiveRecord::Base.connection.execute(sql);
     csv_alldocs = CSV.generate do |csv|
         csv << ["first_name", "last_name", "city", "latitude", "longitude", "country", "organisation"]
         @res.each do |doc|       
           csv << [doc[0], doc[1], doc[2], doc[3], doc[4], doc[5], doc[6]]
         end
  end
     send_data csv_gender,
   :type => 'text/csv; charset=iso-8859-1; header=present',
   :disposition => "attachment; filename=cities.csv" 
end 

    def alldocsforcluster
    # sql = "SELECT cities.longitude, cities.latitude, doctors.id, cities.id, cities.name FROM cities, doctors WHERE cities.id = doctors.city_id AND cities.latitude != ''"
     sqlcities = "SELECT * FROM cities" 
     sql = "SELECT cities.`name`,  districts.`mapbox_obj_id`,
  specialties.`name`, doctors.`id`, districts.`id`, cities.`id` 
FROM doctors, specialties, districts, cities
WHERE doctors.`specialty_id` = specialties.`id` 
AND doctors.`city_id` = cities.`id` 
AND cities.`mapbox_obj_id` = districts.`mapbox_obj_id` 
ORDER BY cities.id"
   
  @res =  ActiveRecord::Base.connection.execute(sql);
   @cities = ActiveRecord::Base.connection.execute(sqlcities);
     csv_alldocs = CSV.generate do |csv|
         csv << ["latitude", "longitude", "docid", "cityId", "cityname"]

         @res.each do |doc|  
          lat = 0.0000
          lon = 0.0000
         
         @cities.each do |cty|  
           
           if cty[8] == doc[1] then

          lat = cty[6]
          lon = cty[5]
          next
           end
          
         end

          csv << [lat, lon, doc[3], doc[5], doc[0]]
         end
  end
     send_data csv_alldocs,
   :type => 'text/csv; charset=iso-8859-1; header=present',
   :disposition => "attachment; filename=cities.csv" 
end 


 def alldocsforclustergeojson
    # organisations.longitude, organisations.latitude
     sqlcities = "SELECT * FROM cities" 
     sql = "SELECT cities.`name`,  districts.`mapbox_obj_id`,
  specialties.`name`, doctors.`id` as doctor_id , districts.`id` as_district_id, cities.`id` as city_id, countries.name, cities.latitude, cities.longitude, organisations.name 
FROM doctors, specialties, districts, cities, countries, organisations
WHERE doctors.`specialty_id` = specialties.`id` 
AND doctors.`city_id` = cities.`id` 
AND cities.`mapbox_obj_id` = districts.`mapbox_obj_id` 
AND cities.country_id = countries.id
AND doctors.city_id = cities.id
and doctors.organisation_id = organisations.id
ORDER BY cities.latitude, cities.longitude"
   
file = File.read("public/PROVINCESDEST.geojson") 
geojson = ActiveSupport::JSON.decode(file)

 crs = Hash.new
 crsprop = Hash.new
 crsprop["name"] = "urn:ogc:def:crs:OGC:1.3:CRS84"
 crs["type"] = "name"
 crs["properties"] = crsprop
 geojson["crs"] = crs

  @res =  ActiveRecord::Base.connection.execute(sql);
  @cities = ActiveRecord::Base.connection.execute(sqlcities);
 
  csv_alldocs = CSV.generate do |csv|

         @res.each do |doc|  
          lat = 0.0000
          lon = 0.0000
        values = Hash.new
        properties = Hash.new
        geometry = Hash.new  
        coordinates = Array.new
        feature = Hash.new
        
        coordinates[0] =  doc[7]
        coordinates[1] =  doc[8]  
         
        geometry["coordinates"] = coordinates
        feature["type"] = "Feature";
        feature["properties"] = properties
        feature["geometry"] = geometry
        geometry["type"] = "Point"
        properties["docid"] = doc[3] 
        properties["cityId"] = doc[5] 
        properties["districtId"] = doc[4] 
        properties["cityname"] = doc[0]
        properties["country"] = doc[6]
        properties["organisation"] = doc[9]
        properties["specialty"] = doc[2]
        properties["organisationlat"] = doc[10]
        properties["organisationlon"] = doc[11]    
        properties["marker-color"] = "#4787BD"
        properties["marker-symbol"] = "1"

          icon = Hash.new
          icon["iconUrl"] = "/images/surgeon_pin.png"
          icon["iconSize"] = [35, 90]
          icon["iconAnchor"] = [17, 48]
          icon["popupAnchor"] = [0, -40]
          icon["className"] = "dot"

       #  properties["icon"] = icon

        geojson["features"] << feature
         end
  end
      json_data = geojson.to_json
      send_data json_data  
end 


def specialtybycountry
     sql = "SELECT  countries.`name`, countries.`latitude`, countries.`longitude`,  specialties.`name`, count(specialties.`name`), countries.`population`, sum(IF(doctors.`gender` = 'Female', 1, 0)) as femalescntr  FROM doctors, countries, specialties WHERE doctors.`country_id` = countries.`id` AND  doctors.`specialty_id` = specialties.`id`  GROUP BY countries.`name`, specialties.`name`"
     sqlspecs = "SELECT  specialties.`name` from specialties"
     sqlcountries = "SELECT  name, longitude, latitude from countries"
    # @cities = Doctor.joins(:city)where.not(longitude: "" ).group()
  @specs = ActiveRecord::Base.connection.execute(sqlspecs);
  @cntrys = ActiveRecord::Base.connection.execute(sqlcountries);
  specs = Array.new
  colnames = Array.new
  cntrys = Array.new
     colnames.push("country")
     colnames.push("longitude")
     colnames.push("latitude")
     colnames.push("nodocscntr")
     colnames.push("population")
     colnames.push("femalescntr")
     @specs.each do |spec|
     specs.push(spec[0])
     colnames.push(spec[0])
    end

  @res =  ActiveRecord::Base.connection.execute(sql);
     csv_gender = CSV.generate do |csv|
         csv <<  colnames
        @cntrys.each do |cntry|
        values = Hash.new
        pop = 0
        nodocs = 0
        females = 0
         @res.each do |city|
         if  cntry[0].eql? city[0] 
         nodocs = nodocs + city[4].to_i
         females = females + city[6].to_i
         pop = city[5].to_i
           
         i=0
         specs.each do |s|
        # puts "specialty is >>>>" + s
          if s.to_s.eql? city[3]
             k=i+4
            values[s] = city[4]
            
          else 
         #  values[s] = 0
          end
           i=i+1

         end # specs.each
         end   # if country.eql? 
        
         end # res.each
         puts  "population >>>> " + pop.to_s
         values["nodocscntr"] = nodocs.to_s
         values["femalescntr"] = females.to_s
         values["country"] = cntry[0]
         values["longitude"] = cntry[2]
         values["latitude"] = cntry[1]
         values["population"] = pop.to_s  
         puts   values["population"].to_s
         csv << values.values_at(*colnames)
       end # cntry.each
  end
  return csv_gender
end


def hospitalsbycountry
  sql = "SELECT  countries.`name`, countries.`latitude`, countries.`longitude`,   count(case `organisations`.`training` when 'y' then 1 else null end ), count(case `organisations`.`training` when 'n' then 1 else null end )  FROM cities, countries, organisations WHERE organisations.`city_id` = cities.`id` AND  cities.country_id = countries.`id`  GROUP BY countries.`name`"
     
  @hospitals = ActiveRecord::Base.connection.execute(sql);
  colnames = Array.new
     colnames.push("country")
     colnames.push("longitude")
     colnames.push("latitude")
     colnames.push("training")
     colnames.push("nontraining")
       csv_hospitals = CSV.generate do |csv|
  
         csv <<  colnames

    @hospitals.each do |hospital|  
     csv << [hospital[0], hospital[1], hospital[2], hospital[3], hospital[4]]
    end
  end 
  send_data csv_hospitals
end


def hospitalsbycountrygeojson
  sql = "SELECT  countries.`name`, countries.`latitude`, countries.`longitude`,   count(case `organisations`.`training` when 'y' then 1 else null end ), count(case `organisations`.`training` when 'n' then 1 else null end )  FROM cities, countries, organisations WHERE organisations.`city_id` = cities.`id` AND  cities.country_id = countries.`id`  GROUP BY countries.`name`"
     
  @hospitals = ActiveRecord::Base.connection.execute(sql);
  colnames = Array.new
     colnames.push("country")
     colnames.push("longitude")
     colnames.push("latitude")
     colnames.push("training")
     colnames.push("nontraining")
       csv_hospitals = CSV.generate do |csv|
         csv <<  colnames
    @hospitals.each do |hospital|  
     csv << [hospital[0], hospital[1], hospital[2], hospital[3], hospital[4]]
    end
  end
  send_data csv_hospitals
end

def specialtybydistrict

sql = "SELECT cities.`name`, districts.`name`, districts.`mapbox_obj_id`,
  specialties.`name`, count(doctors.`id`), districts.`id`, districts.`est_population` 
FROM doctors, specialties, districts, cities
WHERE doctors.`specialty_id` = specialties.`id` 
AND doctors.`city_id` = cities.`id` 
AND cities.`mapbox_obj_id` = districts.`mapbox_obj_id` 
GROUP BY   districts.`id`, cities.`name`, specialties.`name` ORDER BY cities.`name`, districts.`mapbox_obj_id`"
 
# sql="SELECT cities.`name`, districts.`name`, districts.`mapbox_obj_id`,
#  specialties.`name`, count(doctors.`id`), districts.`id`, districts.`est_population` 
# FROM doctors, specialties, districts, cities
# WHERE doctors.`specialty_id` = specialties.`id` 
# AND doctors.`city_id` = cities.`id` 
# AND cities.`mapbox_obj_id` = districts.`mapbox_obj_id` 
# GROUP BY districts.`id`, specialties.`name`"
districtssql = "SELECT * FROM DISTRICTS";
 @specs = ActiveRecord::Base.connection.execute(sql);
 @districts = ActiveRecord::Base.connection.execute(districtssql);
 values = Array.new
 obj_ids = Array.new
 @specs.each_with_index do |spec, index|
   row = Hash.new  
   values.push(row)
   obj_ids.push(spec[2])
 row['city'] =      spec[0]
 row['district'] =  spec[1]
 row['obj_id'] =    spec[2]  
 row['specialty'] = spec[3]
 row['docs'] =      spec[4] 
 row['est_population'] = spec[6] 
 end
@districts.each_with_index do |dist, index|
   row = Hash.new  

if !obj_ids.include? dist[2] then
   values.push(row)
 row['city'] ='No'
 row['district'] =  dist[1]
 row['obj_id'] =    dist[2]  
 row['specialty'] = 'No'
 row['docs'] = 0 
 row['est_population'] = dist[4] 
end
 end

 new_json_data = values.to_json
file = File.open("public/SPECIALTY_BY_DISTRICT.json", "w")  { |file| file.write(new_json_data) }
send_data new_json_data
  end

  def genderbydistrict
 sql="SELECT cities.`name` as city, districts.`name` as district, districts.`mapbox_obj_id`,
  count(case `doctors`.`gender` when 'female' then 1 else null end ) as nofemales, count(case `doctors`.`gender` when 'male' then 1 else null end ) as nomales, districts.`id` 
FROM doctors, specialties, districts, cities
WHERE doctors.`specialty_id` = specialties.`id` 
AND doctors.`city_id` = cities.`id` 
AND cities.`mapbox_obj_id` = districts.`mapbox_obj_id` 
GROUP BY districts.`id`"
 @specs = ActiveRecord::Base.connection.execute(sql);
 values = Array.new
 @specs.each_with_index do |spec, index|
   row = Hash.new  
   values.push(row)
 row['city'] =       spec[0]
 row['district'] =   spec[1]
 row['obj_id'] =     spec[2]  
 row['nomale'] =     spec[3]
 row['nofemale'] =   spec[3]
 row['district_id'] =      spec[4]
 
 end
 new_json_data = values.to_json
file = File.open("public/GENDER_BY_DISTRICT.json", "w")  { |file| file.write(new_json_data) }
render :status=>200, :json=>{ :message=>'ok'} 

  end

def csvdrbyspecialty
     csv_spec = specialtybycountry
      send_data csv_spec,
   :type => 'text/csv; charset=iso-8859-1; header=present',
   :disposition => "attachment; filename=cities.csv" 
end 

def docsbyorganisations

sql = "SELECT cities.name, organisations.id, organisations.name, specialties.name, organisations.training,  organisations.latitude,
       organisations.longitude, count(doctors.id), 
       districts.mapbox_obj_id FROM organisations, cities, doctors, specialties,
       districts WHERE organisations.id = doctors.organisation_id AND 
       doctors.city_id = cities.id AND cities.mapbox_obj_id = districts.mapbox_obj_id AND specialties.id = doctors.specialty_id GROUP BY  organisations.id, specialties.name ORDER BY organisations.id, specialties.name ASC" 
     sqlspecs = "SELECT  specialties.`name` from specialties"
     sqlorgs = "SELECT  organisations.id, cities.name, organisations.name, organisations.longitude, organisations.latitude, organisations.training from organisations, cities, doctors WHERE organisations.id = doctors.organisation_id AND cities.id = doctors.city_id  GROUP BY organisations.id"   
    # @cities = Doctor.joins(:city)where.not(longitude: "" ).group()
  @specs = ActiveRecord::Base.connection.execute(sqlspecs);
  @orgs = ActiveRecord::Base.connection.execute(sqlorgs);
  specs = Array.new
  colnames = Array.new
     colnames.push("organisation")
     colnames.push("city")
     colnames.push("training")
     colnames.push("longitude")
     colnames.push("latitude")
     colnames.push("nodocs")
     @specs.each do |spec|
     specs.push(spec[0])
     colnames.push(spec[0])
    end

    @res =  ActiveRecord::Base.connection.execute(sql);
     csv_organisation = CSV.generate do |csv|
         csv <<  colnames
        @orgs.each do |org|
         if !org[2].eql? 'Unknown Hospitals' 
        values = Hash.new
        pop = 0
        nodocs = 0
         @res.each do |specialty|
         if  specialty[1].eql? org[0] 
         nodocs = nodocs + specialty[7].to_i
           
         
         specs.each do |s|
        puts "specialty is >>>>" + s
          if s.to_s.eql? specialty[3]   
            values[s] = specialty[7]  
          else 
         #  values[s] = 0
          end
          

         end # specs.each
         end   # if specialty.eql? 
        
         end # res.each
         values["nodocs"] = nodocs.to_s
         values["city"] = org[1]
         values["training"] = org[5]
         values["organisation"] = org[2]
         values["longitude"] = org[3]
         values["latitude"] = org[4]
         csv << values.values_at(*colnames)
       end # if org == 'Unknown'
       end # orgs.each
  end
  send_data csv_organisation

end


def searchorgs
  key = '*'
key = params[:key]

# sql = "SELECT organisations.id, organisations.name, cities.name as city , countries.name as country, organisations.training, organisations.latitude, organisations.longitude FROM organisations, countries, cities WHERE cities.id = organisations.city_id AND cities.country_id = countries.id AND (UPPER(organisations.name) LIKE '%"+key.upcase+"%'' or UPPER(countries.name)  LIKE '%"+key.upcase+"%'' )"

# old query just searches  organisations
# sql =  "SELECT organisations.id, organisations.name, cities.name, countries.name, organisations.training, organisations.latitude, organisations.longitude FROM organisations, countries, cities WHERE cities.id = organisations.city_id AND cities.country_id = countries.id AND UPPER(organisations.name) LIKE '%"+key.upcase+"%'"
sql = "SELECT * FROM ngos, countries_codes WHERE internal_yn = 'Y'  AND ngos.hq_cntry_code = countries_codes.country_code AND UPPER(organization_name) LIKE '%"+key.upcase+"%'"
@organisations = ActiveRecord::Base.connection.execute(sql);       
respond_to do |format|
   format.json { render :json => @organisations }
   end
end




def docsbyorganisationsgeojson

sql = "SELECT cities.name, organisations.id, organisations.name, specialties.name, organisations.training,  organisations.latitude,
       organisations.longitude, count(doctors.id),  countries.name FROM organisations, cities, doctors, specialties, countries WHERE organisations.id = doctors.organisation_id AND 
       organisations.city_id = cities.id    AND specialties.id = doctors.specialty_id AND cities.country_id = countries.id GROUP BY  organisations.id, specialties.name ORDER BY organisations.id, specialties.name ASC" 
     sqlspecs = "SELECT  specialties.`name` from specialties"
     sqlorgs = "SELECT  organisations.id, cities.name, organisations.name, organisations.longitude, organisations.latitude, organisations.training from organisations, cities, doctors WHERE organisations.id = doctors.organisation_id AND cities.id = doctors.city_id GROUP BY organisations.id"   
 

file = File.read("public/PROVINCESDEST.geojson") 
geojson = ActiveSupport::JSON.decode(file)
 

 crs = Hash.new
 crsprop = Hash.new
 crsprop["name"] =  "urn:ogc:def:crs:OGC:1.3:CRS84"
 crs["type"] = "name"
 crs["properties"] = crsprop
 
 geojson["crs"] = crs


   
  @specs = ActiveRecord::Base.connection.execute(sqlspecs);
  @orgs = ActiveRecord::Base.connection.execute(sqlorgs);
  specs = Array.new
  colnames = Array.new
     colnames.push("organisation")
     colnames.push("city")
     colnames.push("training")
     colnames.push("nodocs")
     @specs.each do |spec|
     specs.push(spec[0])
     colnames.push(spec[0])
    end

    @res =  ActiveRecord::Base.connection.execute(sql);
     csv_organisation = CSV.generate do |csv|
         csv <<  colnames
        @orgs.each do |org|

         if !org[2].eql? 'Unknown Hospitals' 
        values = Hash.new
        properties = Hash.new
        geometry = Hash.new  
        coordinates = Array.new
        feature = Hash.new
        pop = 0
        nodocs = 0
         @res.each do |specialty|

         if  specialty[1].eql? org[0] 
         nodocs = nodocs + specialty[7].to_i
           
         
         specs.each do |s|

        puts "specialty is >>>>" + s
          if s.to_s.eql? specialty[3]   
            properties[s] = specialty[7]  
          else 
         #  values[s] = 0
          end     

         end # specs.each
          properties["country"] = specialty[8]
         end   # if specialty.eql? 
       
         end # res.each
         feature["type"] = "Feature";
         feature["properties"] = properties
         feature["geometry"] = geometry
         geometry["type"] = "Point"
         
         coordinates[0] = org[3]
         coordinates[1] = org[4]
         geometry["coordinates"] = coordinates
          
         properties["nodocs"] = nodocs.to_s
         properties["city"] = org[1]
         properties["training"] = org[5]
         properties["organisation"] = org[2]
         properties["marker-color"] = color("#B82929")
         properties["marker-symbol"] = '1'
         icon = Hash.new
          icon["iconUrl"] = "/images/hospital_pin.png"
          if org[5] == 'y' then
          icon["iconUrl"] = "/images/training_center_pin.png"
          end

          icon["iconSize"] = [20, 20]
          icon["iconAnchor"] = [17, 48]
          icon["popupAnchor"] = [0, -40]
          icon["className"] = "dot"
        # properties["icon"] = icon
         geojson["features"] << feature
       end # if org == 'Unknown'
       end # orgs.each
  end
  json_data = geojson.to_json
  send_data json_data  
end

def color(c) 
colors = Hash.new

      colors['Ethiopia'] = "#CB4133"
      colors['Kenya'] = '#71CB33'
      colors['Rwanda'] = '#33BDCB'
      colors['Uganda'] = '#8D33CB'
      colors['Zambia'] = '#E8B72E'
      colors['Zimbabwe'] = '#E82EE5' 
      colors['Malawi'] = '#2E9EE8'
      colors['Tanzania'] = '#5AC79F'
      colors['Mozambique'] = '#55BD97'
      colors['Burundi'] = '#52B38F'
return '#CB4133'
 
end

def geojsonprovinces 
file = File.read("public/DISTRICTSGEOJSON.geojson")
filedest = File.read("public/PROVINCESDEST.geojson") 
geojson = ActiveSupport::JSON.decode(file)
geojsondest = ActiveSupport::JSON.decode(filedest) 
csv = CSV.generate do |cs|
 cs << ["name", "mapbox_obj_id", "country_id", "est_population"]
geojson["features"].each_with_index do |province, index|
if ['KEN', 'RWA', 'BDI', 'UGA', 'ZMB', 'ZWE', 'TZA', 'MWI', 'ETH', 'MOZ' ].include?   province['properties']['ISO'] then
 puts "MATCH!!!! >>>>" + province['properties']['ISO']
 cntcds =  { 'KEN' =>2, 'RWA'=>3, 'BDI'=>10, 'UGA'=>4, 'ZMB'=>5, 'ZWE'=>6, 'TZA'=>8, 'MWI'=>7, 'ETH'=>1, 'MOZ'=>9 }
 geojsondest["features"].push(province) 
 cs << [ province['properties']['NAME_1'], province['properties']['OBJECTID'], cntcds[province['properties']['ISO']] , 0 ]
end
end
end
new_json_data = geojsondest.to_json
file = File.open("public/PROVINCESSOURCE.geojson", "w")  { |file| file.write(new_json_data) }
send_data csv
end






def geojson 
# file = File.read("public/COSECA_COUNTRIES.geojson")
file = File.read("public/PROVINCESETHKEN.geojson")
csv_spec = specialtybycountry    
geojson = ActiveSupport::JSON.decode(file)
csv = CSV.new(csv_spec)
headers = csv.shift.map {|i| i.to_s }
data = csv.map {|row| row.map {|cell| cell.to_s } }
array_of_hashes = data.map {|row| Hash[*headers.zip(row).flatten] }

array_of_hashes.each do |row| 
puts row
geojson["features"].each do |country|
       
       country['properties'].delete('pctdoctors')
       country['properties'].delete('Region_C_1')
       country['properties'].delete('Region_C_2')
       country['properties'].delete('Region_C_3')
       country['properties'].delete('RegionVar')
       country['properties'].delete('REMARKS_1')
       country['properties'].delete('LabelRank')
       country['properties'].delete('Abbrev')
       country['properties'].delete('NI_NAME_1')
       country['properties'].delete('HASC_1')
       country['properties'].delete('OB/GYN')
       country['properties'].delete('(Cardio)thoracic')
       country['properties'].delete('VALIDFR_1')
       country['properties'].delete('ENGTYPE_1')
       country['properties'].delete('VALIDTO_1')
       country['properties'].delete('DataRank')
       country['properties'].delete('Postal')
       country['properties'].delete('sameAsCity')
       country['properties'].delete('MAP_COLOR')
       country['properties'].delete('FIRST_FIPS')
       country['properties'].delete('FIRST_HASC')
       country['properties'].delete('Region_c3')

if country['properties']['NAME_0'] == row['country'] then

row.each_with_index do |r, index|
   r[1] == '' ? r[1] = '0' : r[1] = r[1]
   if index != 0 
   country['properties'][r[0]] = r[1].to_f

end
end
avg = (row['nodocscntr'].to_f  * 100000) / row['population'].to_f 
femalescntr = (row['femalescntr'].to_f  * 100) / row['nodocscntr'].to_f 
        country['properties']['population'] = row['population']
        country['properties']['pctdocs'] = avg.round(2)
        country['properties']['femalescntr'] = femalescntr.round(2)
end
# country.properties.admin
end
end
new_json_data = geojson.to_json
file = File.open("public/PROVINCESETHKEN.geojson", "w")  { |file| file.write(new_json_data) }
send_data new_json_data
end

def correctcoordinates 
# file = File.read("public/COSECA_COUNTRIES.geojson")
file = File.read("public/PROVINCESETHKEN.geojson")
   
geojson = ActiveSupport::JSON.decode(file)

geojson["features"].each do |province| 

coords = province['geometry']['coordinates']
coords.each_with_index  do |coord, index| 

coord.each_with_index do |coor, inde|
coor.each_with_index do |coo, ind|
# coo.each_with_index do |co, i|
# end

  c1 = (coo[0].to_f / 100000 ) 
  c2 = (coo[1].to_f / 100000 ) 
    
  coords[index][inde][ind][0] =  c1.round(6) - 5
  coords[index][inde][ind][1] =  c2.round(6) - 1.5

   puts coo.to_s + " --->> "   + ind.to_s 
end
end
end
      
end
 

new_json_data = geojson.to_json
file = File.open("public/PROVINCES3.geojson", "w")  { |file| file.write(new_json_data) }
send_data new_json_data
end

def refreshdistricts
file = File.read("public/PROVINCESETHKEN.geojson")
provincesjson = ActiveSupport::JSON.decode(file)
sql = "SELECT `districts`.`id`, `districts`.`name`, `districts`.`mapbox_obj_id`, `districts`.`est_population`, count(`doctors`.`id`) as nodocs,  
 count(case `doctors`.`gender` when 'female' then 1 else null end ) as nofemales FROM `districts`, `cities`, doctors 
 WHERE `districts`.`mapbox_obj_id` = `cities`.`mapbox_obj_id` AND `cities`.`id` = `doctors`.`city_id`  GROUP BY `districts`.`id`"
@docsbyprovinces = ActiveRecord::Base.connection.execute(sql);

# set everything to 0 first 
provincesjson["features"].each do |prov|
  prov['properties']['est_population'] = 0.0
  prov['properties']['nodocs'] = 0.0
  prov['properties']['pctdocsbydistrict'] = 0.0

   prov['properties'].delete('ProvNumber')
end

provincesjson["features"].each do |prov|
#now set actual no of docs per province
puts prov['properties']['OBJECTID']
@docsbyprovinces.each do |dbdistrict|
  if dbdistrict[2].to_i == prov['properties']['OBJECTID'].to_i
  pctfemales = dbdistrict[5].to_f * 100 / dbdistrict[4].to_f 
  puts "DISTRICT FROM DB MATCHED WITH DISTRICT FORM JSON!! >>>>" + dbdistrict[2].to_s
  prov['properties']['est_population'] = dbdistrict[3].to_f
  prov['properties']['nodocs'] = dbdistrict[4].to_f
  prov['properties']['pctfemales'] = pctfemales.round(2)
  pdbd =  (dbdistrict[4].to_f * 100000) / dbdistrict[3].to_f
   prov['properties']['pctdocsbydistrict'] = pdbd.round(2)
  end



end
end
new_json_data = provincesjson.to_json
file = File.open("public/PROVINCESETHKEN.geojson", "w")  { |file| file.write(new_json_data) }
render :status=>200, :json=>{ :message=>'ok'}  

end

def euaus

file = File.read("public/PROVINCESEU11.geojson")
provincesjson = ActiveSupport::JSON.decode(file)
 cntrsarray = ['Australia', 'France', 'United Kingdom']
# set everything to 0 first 
provincesjson["features"].each do |prov|
 if  not cntrsarray.include?(prov['properties']['NAME_0']) then
   provincesjson["features"].delete(prov) 
 end

end

new_json_data = provincesjson.to_json
file = File.open("public/PROVINCESEU12.geojson", "w")  { |file| file.write(new_json_data) }
render :status=>200, :json=>{ :message=>'ok'}  
end


def refreshcountries
file = File.read("public/COUNTRIES5.geojson")
countriesjson = ActiveSupport::JSON.decode(file)
countries = Array.new

countries = ['Ethiopia', 'Kenya', 'Rwanda', 'Uganda', 'Zambia', 'Zimbabwe', 'Malawi', 'Tanzania', 'Mozambique', 'Burundi' ]
  
# set everything to 0 first 
countriesjson["features"].each_with_index do | cntr , index|
  puts  countriesjson['features'].count
 if not countries.include? cntr['properties']['NAME']  then
 countriesjson['features'].delete(cntr)  
 end
   
end

new_json_data =  countriesjson.to_json
file = File.open("public/COUNTRIES6.geojson", "w")  { |file| file.write(new_json_data) }
render :status=>200, :json=> new_json_data   

end


def csvcities
  file = File.read("public/cities.geojson")
   geojson = ActiveSupport::JSON.decode(file)
csv = CSV.generate do |cs|
    cs << ["name", "district", "country"]
geojson["features"].each do |cty|
  if ['KEN', 'RWA', 'BDI', 'UGA', 'ZMB', 'ZWE', 'TZA', 'MWI', 'ETH', 'MOZ' ].include?   cty['properties']['ADM0_A3'] then
  cs << [cty['properties']['NAMEASCII'], cty['properties']['ADM1NAME'], cty['properties']['ADM0NAME'] ]
end
end
end
send_data csv
end

def docsbycity
  sql = "SELECT cities.longitude, cities.latitude, cities.name, count(doctors.id), cities.id FROM cities, doctors WHERE cities.id = doctors.city_id AND cities.latitude != '' GROUP BY cities.id"
@docsbycity = ActiveRecord::Base.connection.execute(sql);
csv = CSV.generate do |cs|
    cs << ["latitude", "longitude", "city", "nodocs"]
@docsbycity.each do |cty|
   
  cs << [cty[0], cty[1], cty[2], cty[3] ]
end
end
send_data csv
end

def docsbydistrict
sql = "SELECT cities.longitude, cities.latitude,  districts.name, districts.mapbox_obj_id, count(doctors.id), cities.id, cities.name FROM cities, doctors, districts WHERE cities.id = doctors.city_id AND cities.latitude != '' AND cities.mapbox_obj_id = districts.mapbox_obj_id  GROUP BY cities.id,  districts.mapbox_obj_id ORDER BY  districts.mapbox_obj_id"
@docsbycity = ActiveRecord::Base.connection.execute(sql);

districtsarray = Array.new;
temparray = Array.new;
tempdistrict = '*'
docsbydistrict = 0
@docsbycity.each_with_index do |cty, index|
  cnt = districtsarray.count - 1
if !tempdistrict.eql? cty[2] 
   tempdistrict = cty[2]
   districtsarray.push(cty)
   cnt = districtsarray.count - 1
   docsbydistrict = 0;
   docsbydistrict = docsbydistrict + cty[4]
   districtsarray[cnt][4] = docsbydistrict
   puts  districtsarray[cnt][2] + ' ...' + cty[2] + ' PUSH DOCS>>>' + districtsarray[cnt][4].to_s
   
else
docsbydistrict = docsbydistrict + cty[4]
districtsarray[cnt][4] = docsbydistrict
# puts  districtsarray[cnt][2] + ' ...' + cty[2] + 'ADD DOCS>>>' + districtsarray[cnt][4].to_s
end

end

csv = CSV.generate do |cs|
    cs << [ "latitude", "longitude", "city", "mapbox_obj_id", "nodocs"]
districtsarray.each do |cty|
   
  cs << [cty[0], cty[1], cty[2], cty[3], cty[4]]
end
end
send_data csv
end

def geojsoncities 
mapcities
end

def regionsfromexcel

cities = City.where(:mapbox_obj_id => nil) 
mapped = File.read("public/mapped.csv")
file = File.read("public/PROVINCES.geojson")
geojson = ActiveSupport::JSON.decode(file)
mapbox_district_codes = Hash.new
map_city_to_district_code = Hash.new
geojson["features"].each_with_index do |province, index|
mapbox_district_codes[province['properties']['NAME_1']] =  province['properties']['OBJECTID']

end

csv = CSV.parse(mapped, :headers => true)
csv.each do |row|
   
r =  row.to_hash
map_city_to_district_code[r['name']] = mapbox_district_codes[r['district']]
end


map_city_to_district_code.each do |c|
 puts c[0] +   " >>>> " + c[1].to_s
   City.where('name = ?',  c[0]).update_all(:mapbox_obj_id => c[1])
 
 end  
render :status=>200, :json=>{ :message=>'ok'}  
end

def mapcities
cities = City.where(:mapbox_obj_id => nil) 
file = File.read("public/cities.geojson")
geojsoncities = ActiveSupport::JSON.decode(file)
citarr = Array.new
cnt = 0
nocnt = 0
cities.each do |c| 
citarr.push(c.name)
puts c.name
end 
geojsoncities["features"].each_with_index do |city, index|

if citarr.include?   city['properties']['NAME']  then

@d = District.where(:name => city['properties']['ADM1NAME'])

cnt+=1
 City.where('name = ?', city['properties']['NAME']).update_all(:mapbox_obj_id =>  @d.first.mapbox_obj_id)    
 citarr.delete(city['properties']['NAME'].upcase)
  
end
end
puts cnt.to_s + ' cities matched !!!'
csv = CSV.generate do |cs|
    cs << ["name"]
    citarr.each do |c|
    cs << [c]
    end
  end
  send_data csv
#  render :status=>200, :json=>{ :message=>'ok', :notmatched=>nocnt}   
end
end
