class StatsController < ApplicationController
require 'csv'

def statspercountry
sql = "SELECT * FROM countries_stats WHERE country_code is not null"
file = File.read("public/COUNTRIES2.geojson")
geojsonstats = ActiveSupport::JSON.decode(file.force_encoding("ISO-8859-1").encode("UTF-8"))

@statsbycountries = ActiveRecord::Base.connection.execute(sql);
 features = Array.new

 @statsbycountries.each_with_index do |country, index|
   row = Hash.new 
   feature = Hash.new
   feature['type'] = 'feature'
  #puts 'country 0 is >>>' + country[0]
    row['ne_10m_adm'] = country[0]
    row['population'] = country[2]
    row['surgeons'] = country[3]
    row['anesthesiologists'] =  country[5]
    row['obstetricians'] = country[4]
    row['ADM_0'] = country[0]  
   
  geojsonstats["features"].each do |cnt|
    countrygeojson =  cnt['properties']['ISO_A3'].strip
    countrydatabase =  country[0].strip
   if countrygeojson == countrydatabase then
    puts country[0] + '<<< >>>>>>' + cnt['properties']['ISO_A3']
   	cnt['properties']['population'] = country[2]
    cnt['properties']['surgeons'] =   country[3]
    cnt['properties']['anesthesiologists'] = country[5]
    cnt['properties']['totalsurgeons'] = country[5] + country[4] + country[3]
    totalsurgeons =  country[5].to_i + country[4].to_i + country[3].to_i
    surgperhundredk = 0.0
    if  totalsurgeons > 0 then
    surgperhundredk =  totalsurgeons / (country[2].to_f / 100000.00).round(1)
   end 

    cnt['properties']['surgperhundredk'] = surgperhundredk 
    cnt['properties']['obstetricians'] =   country[4]
  
    else
  end
  feature['properties'] = row
end
   features.push(feature)
 end

new_json_data = geojsonstats.to_json
file = File.open("public/COUNTRIESSTATS.geojson", "w")  { |file| file.write(new_json_data) }
render :status=>200, :json=>{ :message=>'ok', :data=>new_json_data } 
end


def statsforoverlay
sql = "SELECT * FROM countries_stats WHERE country_code is not null"
file = File.read("public/COUNTRIES.geojson")
geojsonstats = ActiveSupport::JSON.decode(file.force_encoding("ISO-8859-1").encode("UTF-8"))

@statsbycountries = ActiveRecord::Base.connection.execute(sql);
 features = Array.new

 @statsbycountries.each_with_index do |country, index|
  row = Hash.new 
  feature = Hash.new
  feature['type'] = 'feature'
  puts 'country 0 is >>>' + country[0]
    row['ne_10m_adm'] = country[0]
    row['population'] = country[2]
    row['surgeons'] = country[3]
    row['anesthesiologists'] =  country[5]
    row['obstetricians'] = country[4]
   row['ADM_0'] = country[0]  
   
  geojsonstats["features"].each do |cnt|
    countrygeojson =  cnt['properties']['ISO3'].strip
    countrydatabase =  country[0].strip
      puts country[0] + '<<< >>>>>>' + cnt['properties']['ISO3']
   if countrygeojson == countrydatabase then
    puts country[0] + '<<< >>>>>>' + cnt['properties']['ISO3']
    cnt['properties']['population'] = country[2]
    cnt['properties']['surgeons'] =   country[3]
    cnt['properties']['anesthesiologists'] = country[5]
    cnt['properties']['totalsurgeons'] = country[5] + country[4] + country[3]
    totalsurgeons =  country[5].to_i + country[4].to_i + country[3].to_i
    surgperhundredk = 0.0
    if  totalsurgeons > 0 then
    surgperhundredk =  totalsurgeons / (country[2].to_f / 100000.00).round(1)
   end 

    cnt['properties']['surgperhundredk'] = surgperhundredk 
    cnt['properties']['obstetricians'] =   country[4]
  
    else
  end
  feature['properties'] = row
end
   features.push(feature)
 end

new_json_data = geojsonstats.to_json
file = File.open("public/STATSFOROVERLAY.geojson", "w")  { |file| file.write(new_json_data) }
render :status=>200, :json=>{ :message=>'ok', :data=>new_json_data } 
end

end