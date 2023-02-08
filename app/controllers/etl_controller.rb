class EtlController < ApplicationController
 
require 'csv'
require 'browser'

def deletekenyaethiopiaborders 
 
 file_borders = File.read("public/PROVINCESSOURCE.geojson")
 
 geojson_borders = ActiveSupport::JSON.decode(file_borders)
 puts geojson_borders['features'].count()  
 
geojson_borders['features'].each do |prov|
  countries = Array.new
  countries.push('Ethiopia')  
  countries.push('Kenya')
   

name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
 
  
  if   countries.include? name   then
  geojson_borders['features'].delete(prov) 
  puts  prov['properties']["NAME_1"].to_s + '>>>>'  +  prov['properties']["OBJECTID"].to_s

  end 

end

geojson_borders['features'].each do |prov|
 
  ids = Array.new
  ids.push(3110)
  ids.push(3130)
  ids.push(3132)
  ids.push(3134)
  ids.push(3136)
  ids.push(890)
  ids.push(893)
  ids.push(1196)

name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
id = prov['properties']['OBJECTID']
  
  if   ids.include? id   then
  geojson_borders['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
   
  end 

end

geojson_borders['features'].each do |prov|
 
  ids = Array.new
  ids.push(3110)
  ids.push(3130)
  ids.push(3132)
  ids.push(3134)
  ids.push(3136)
  ids.push(890)
  ids.push(893)
  ids.push(1196)

name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
id = prov['properties']['OBJECTID']
  
  if   ids.include? id   then
  geojson_borders['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
   
  end 
end

geojson_borders['features'].each do |prov|
 
  ids = Array.new
  ids.push(3110)
  ids.push(3130)
  ids.push(3132)
  ids.push(3134)
  ids.push(3136)
  ids.push(890)
  ids.push(893)
  ids.push(1196)

name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
id = prov['properties']['OBJECTID']
  
  if   ids.include? id   then
  geojson_borders['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
   
  end 
end

    puts geojson_borders['features'].count()
  return geojson_borders
end


def deletekenyaethiopia 
 file_provinces = File.read("public/PROVINCES2.geojson")
 file_borders = File.read("public/PROVINCESSOURCE.geojson")
 geojson_provinces = ActiveSupport::JSON.decode(file_provinces)
 geojson_borders = ActiveSupport::JSON.decode(file_borders)
 puts geojson_provinces['features'].count()  
 
geojson_provinces['features'].each do |prov|
  countries = Array.new
  countries.push('Ethiopia')  
  countries.push('Kenya')
   

name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
 
  
  if   countries.include? name   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s

  end 

end

geojson_provinces['features'].each do |prov|
 
  ids = Array.new
  ids.push(3110)
  ids.push(3130)
  ids.push(3132)
  ids.push(3134)
  ids.push(3136)
  ids.push(890)
  ids.push(893)
  ids.push(1196)

name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
id = prov['properties']['OBJECTID']
  
  if   ids.include? id   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
   
  end 

end

geojson_provinces['features'].each do |prov|
 
  ids = Array.new
  ids.push(3110)
  ids.push(3130)
  ids.push(3132)
  ids.push(3134)
  ids.push(3136)
  ids.push(890)
  ids.push(893)
  ids.push(1196)

name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
id = prov['properties']['OBJECTID']
  
  if   ids.include? id   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
   
  end 
end

geojson_provinces['features'].each do |prov|
 
  ids = Array.new
  ids.push(3110)
  ids.push(3130)
  ids.push(3132)
  ids.push(3134)
  ids.push(3136)
  ids.push(890)
  ids.push(893)
  ids.push(1196)

name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
id = prov['properties']['OBJECTID']
  
  if   ids.include? id   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
   
  end 
end

    puts geojson_provinces['features'].count()
  return geojson_provinces
end
 
def extractdistrictsnames
 
 file_eth = File.read("public/ethiopia_geojson.geojson")
 file_ken = File.read("public/kenya_geojson.geojson")
 geojson_eth = ActiveSupport::JSON.decode(file_eth)
 geojson_ken = ActiveSupport::JSON.decode(file_ken)
 
      csv_eth = CSV.generate do |csv|
         csv << ["name", "mapbox_obj_id","country_id"]
      geojson_eth['features'].each do |dstrct|
      name = dstrct['properties']['REGIONNAME'] + ' - ' + dstrct['properties']['ZONENAME'] 	 
      mapbox_id = '1111' + dstrct['properties']['OBJECTID'].to_s
        csv << [name,  mapbox_id, '1', 0]
      end

      geojson_ken['features'].each do |dstrct|
      name = dstrct['properties']['Province'] + ' -' + dstrct['properties']['COUNTY'] 	 
      mapbox_id = '2222' + dstrct['properties']['OBJECTID_1'].to_s
        csv << [name,  mapbox_id, '2',  0]
      end

    end
 send_data csv_eth
end


 def addethiopia
 file_eth = File.read("public/ethiopia_geojson.geojson")
 geojson_eth = ActiveSupport::JSON.decode(file_eth)
 geojson_provinces = deletekenyaethiopia
 puts 'in addkenteh  >>>' + geojson_provinces['features'].count().to_s  
 geojson_borders = deletekenyaethiopiaborders
  geojson_eth['features'].each do |dstrct|
        properties = Hash.new
        propertiesborders = Hash.new
        geometry = Hash.new         
        coordinates = Array.new        
        feature = Hash.new
        featureborders = Hash.new
        properties['OBJECTID'] = '1111' + dstrct['properties']['OBJECTID'].to_s
        propertiesborders['OBJECTID'] = '1111' + dstrct['properties']['OBJECTID'].to_s
        feature["type"] = "Feature";
        featureborders["type"] = "Feature";
        coordinates = dstrct['geometry']['coordinates']      
        properties["VertexCou"] = 237.0
        propertiesborders["VertexCou"] = 237.0
        properties["ISO"] = 'ETH'
        propertiesborders["ISO"] = 'ETH'
        properties["NAME_0"] = 'Ethiopia'
        propertiesborders["NAME_0"] = 'Ethiopia'
        properties["NAME_1"] =  dstrct['properties']['REGIONNAME'] + ' - ' + dstrct['properties']['ZONENAME']    
        propertiesborders["NAME_1"] =  dstrct['properties']['REGIONNAME'] + ' - ' + dstrct['properties']['ZONENAME']        
        properties["VARNAME_1"] =  dstrct['properties']['ZONENAME']
        propertiesborders["VARNAME_1"] =  dstrct['properties']['ZONENAME']
        properties["TYPE_1"] = 'Zone'
        propertiesborders["TYPE_1"] = 'Zone'    
        properties["Region"] = 'null'
        propertiesborders["Region"] = 'null'
        properties["NEV_Countr"] =  "Ethiopia"
        propertiesborders["NEV_Countr"] =  "Ethiopia"
        properties["FIPS_1"] = 'ET' + properties['OBJECTID'].to_s
        propertiesborders["FIPS_1"] = 'ET' + properties['OBJECTID'].to_s
        properties["ADM0_A3"] = 'ETH'
        propertiesborders["ADM0_A3"] = 'ETH' 

        properties["est_population"] = 0.0
        properties["nodocs"] = 0.0
        properties["longitude"] = 38.967284,
        properties["latitude"] = 9.196953, 
        properties["Pediatrics"] = 0.0,
        properties["General"] = 0.0,
        properties["Orthopaedics"] = 0.0,
        properties["Urology"] = 0.0,
        properties["Plastics"] = 0.0,
        properties["Colorectal"] = 0.0,
        properties["Cardiovascular"] = 0.0,
        properties["ENT"] = 0.0,
        properties["Oral and Maxillofacial"] = 0.0,
        properties["Opthalmic"] = 0.0,
        properties["Neurosurgery"] = 0.0,
        properties["pctdocs"] = 0.0,
        properties["population"] = 100000,
        properties["nodocscntr"] = 0.0,
        properties["pctdocsbydistrict"] = 0.0,
        properties["Cardiothoracic"] = 0.0,
        properties["OB-GYN"] = 0.0,
        properties["pctfemales"] = 0.0,
        properties["Unknown"] = 0.0,
        properties["femalescntr"] = 0.0,
        properties["Cleft"] = 0.0,
        properties["Trauma"] = 0.0,
        properties["Neuro"] = 0.0
        geometry["type"] = "MultiPolygon"
        geometry["coordinates"] =  coordinates 

        feature["properties"] = properties
        feature["geometry"] = geometry
        featureborders["properties"] = propertiesborders
        featureborders["geometry"] = geometry
  geojson_provinces["features"] << feature
   geojson_borders["features"] << featureborders
     end
  addkenya(geojson_provinces, geojson_borders) 
 end
 
 def addkenya geojson_provinces, geojson_borders

 file_ken = File.read("public/kenya_geojson.geojson")
 geojson_ken = ActiveSupport::JSON.decode(file_ken)
  
  geojson_ken['features'].each do |dstrct|
        properties = Hash.new
        propertiesborders = Hash.new
        geometry = Hash.new  
        coordinates = Array.new
        feature = Hash.new
        featureborders = Hash.new

        properties['OBJECTID'] = '2222' + dstrct['properties']['OBJECTID_1'].to_s
        propertiesborders['OBJECTID'] = '2222' + dstrct['properties']['OBJECTID_1'].to_s
        feature["type"] = "Feature";
        featureborders["type"] = "Feature";
        coordinates = dstrct['geometry']['coordinates']      
        properties["VertexCou"] = 207.0
        propertiesborders["VertexCou"] = 207.0
        properties["ISO"] = 'KEN'
        propertiesborders["ISO"] = 'KEN'
        properties["NAME_0"] = 'Kenya'
        propertiesborders["NAME_0"] = 'Kenya'
        properties["NAME_1"] =  dstrct['properties']['Province'] + ' - ' + dstrct['properties']['COUNTY']    
        properties["VARNAME_1"] =  dstrct['properties']['COUNTY']
        properties["TYPE_1"] = 'County'
        properties["Region"] = 'null'
        properties["NEV_Countr"] =  "Kenya"
        properties["FIPS_1"] = 'KE' + properties['OBJECTID_1'].to_s
        properties["ADM0_A3"] = 'KEN' 
        properties["est_population"] = 0.0
        properties["nodocs"] = 0.0
        properties["longitude"] = 37.477071,
        properties["latitude"] = 0.169145, 
        properties["Pediatrics"] = 0.0,
        properties["General"] = 0.0,
        properties["Orthopaedics"] = 0.0,
        properties["Urology"] = 0.0,
        properties["Plastics"] = 0.0,
        properties["Colorectal"] = 0.0,
        properties["Cardiovascular"] = 0.0,
        properties["ENT"] = 0.0,
        properties["Oral and Maxillofacial"] = 0.0,
        properties["Opthalmic"] = 0.0,
        properties["Neurosurgery"] = 0.0,
        properties["pctdocs"] = 0.0,
        properties["population"] = 100000,
        properties["nodocscntr"] = 0.0,
        properties["pctdocsbydistrict"] = 0.0,
        properties["Cardiothoracic"] = 0.0,
        properties["OB-GYN"] = 0.0,
        properties["pctfemales"] = 0.0,
        properties["Unknown"] = 0.0,
        properties["femalescntr"] = 0.0,
        properties["Cleft"] = 0.0,
        properties["Trauma"] = 0.0,
        properties["Neuro"] = 0.0
        geometry["type"] = "MultiPolygon"
        geometry["coordinates"] =  coordinates 
        feature["properties"] = properties
        feature["geometry"] = geometry
        featureborders["properties"] = propertiesborders
        featureborders["geometry"] = geometry
  geojson_provinces["features"] << feature
   geojson_borders["features"] << featureborders
     end
borders_json_data = geojson_borders.to_json
 file = File.open("public/PROVINCESSOURCEETHKEN.geojson", "w")  { |file| file.write(borders_json_data) }
 new_json_data = geojson_provinces.to_json
   send_data new_json_data 
 end


#################################################################################
#################################################################################


def deleteukfraaus 
 file_provinces = File.read("public/PROVINCESETHKEN.geojson")
 file_borders = File.read("public/PROVINCESSOURCEETHKEN.geojson")
 geojson_provinces = ActiveSupport::JSON.decode(file_provinces)
 geojson_borders = ActiveSupport::JSON.decode(file_borders)
 puts geojson_provinces['features'].count()  

  countries = Array.new
  countries.push('France')  
  countries.push('United Kingdom')
  countries.push('Australia') 

## No1 
geojson_provinces['features'].each do |prov|
name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8")  
  if   countries.include? name   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
  end 
end

## No2
geojson_provinces['features'].each do |prov|
name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
  if   countries.include? name   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
  end 
end

## No3 
geojson_provinces['features'].each do |prov|
name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
  if   countries.include? name   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
  end 
end

## No4 
geojson_provinces['features'].each do |prov|
name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
  if   countries.include? name   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
  end 
end

## No5 
geojson_provinces['features'].each do |prov|
name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
  if   countries.include? name   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
  end 
end

## No6 
geojson_provinces['features'].each do |prov|
name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
  if   countries.include? name   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
  end 
end

## No7 
geojson_provinces['features'].each do |prov|
name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
  if   countries.include? name   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
  end 
end

## No8 
geojson_provinces['features'].each do |prov|
name = prov['properties']['NAME_0'].encode("iso-8859-1").force_encoding("utf-8") 
  if   countries.include? name   then
  geojson_provinces['features'].delete(prov) 
  puts  prov['properties']["NAME_1"] + '>>>>'  +  prov['properties']["OBJECTID"].to_s
  end 
end
    puts geojson_provinces['features'].count()
    new_json_data = geojson_provinces.to_json
    file = File.open("public/PROVINCESSOURCEETHKENNOUKFRAUS.geojson", "w")  { |file| file.write(new_json_data) }

  send_data new_json_data 
end


end
 