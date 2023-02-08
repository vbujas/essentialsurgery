class DriveController < ApplicationController
  before_action :authenticate_user!
   
  layout 'admin_panel'
 
require "google_drive"

def index
end
# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.

def makeconnection table

session = GoogleDrive.saved_session("google_drive.json")


if table== 'organisations' then
sheet = session.spreadsheet_by_key("1EPLYBDY5lxXVqRr9EbxtUHjk-iinelAi6ZGwN1Qv0cs").worksheets[1]
elsif table== 'cities' then
	
sheet = session.spreadsheet_by_key("1EPLYBDY5lxXVqRr9EbxtUHjk-iinelAi6ZGwN1Qv0cs").worksheets[5]
elsif table== 'countries' then
	
sheet = session.spreadsheet_by_key("1EPLYBDY5lxXVqRr9EbxtUHjk-iinelAi6ZGwN1Qv0cs").worksheets[3]
elsif table== 'specialties' then
	
sheet = session.spreadsheet_by_key("1EPLYBDY5lxXVqRr9EbxtUHjk-iinelAi6ZGwN1Qv0cs").worksheets[2]
elsif table== 'doctors' then
	
sheet = session.spreadsheet_by_key("1EPLYBDY5lxXVqRr9EbxtUHjk-iinelAi6ZGwN1Qv0cs").worksheets[0]
elsif table== 'districts' then
	
sheet = session.spreadsheet_by_key("1EPLYBDY5lxXVqRr9EbxtUHjk-iinelAi6ZGwN1Qv0cs").worksheets[4]
end

return sheet;
end



def import 
# Gets content of A2 cell.
#p ws[2, 1]  #==> "hoge"
puts "HERE's PARAM"
puts params['drive']['table']
sheet = makeconnection(params['drive']['table'])
 
@num_rows = sheet.num_rows
@num_cols = sheet.num_cols
# Changes content of cells.
# Changes are not sent to the server until you call ws.save().
# ws[2, 1] = "foo"
# ws[2, 2] = "bar"
# ws.save
# Dumps all cells.
# @table = Hash.new
# (1..ws.num_rows).each_with_index do |ind, row|
# @table[ind] = row
# (1..ws.num_cols).each_with_index do |index, col|
# end
# end
@table=  sheet.rows #==> [["fuga", ""], ["foo", "bar]]

# Yet another way to do so.
# Reloads the worksheet to get changes by other clients.
##ws.reload
if params['drive']['table'] == 'doctors' then

@inserted = insertdoctors( @table, params['drive']['table'] )


else
@inserted = maketransaction( @table, params['drive']['table'] )
end if

# @res =  ActiveRecord::Base.connection.execute(@sql);
nr = @num_rows - 1
noinsert = nr - @inserted.count()

text = noinsert.to_s  + ' out of ' + nr.to_s + 'rows inserted. ' 
 render :status=>200, :json=>{ :message=> text, :errors=>@inserted} 

 

end

def insertdoctors(table, tablename)

@errors = Array.new

table.each_with_index do |row, ind|

	if ind > 0 then
  
 
 d =  Doctor.where(id: row[0] ).first_or_initialize.tap() do |d|  
     d.id = row[0].to_i
     d.first_name =  row[2]
     if !d.gender ||  d.gender == '' then
      d.gender = row[7]
    end
   
    if d.title.present?   then
       d.title = d.title
    else 
       d.title = 'Dr'
    end


     if d.middle_name.present?  then
      d.middle_name = d.middle_name
    else
      d.middle_name = ' '
    end
       if d.fellow_type_id.present?  then
      d.fellow_type_id = d.fellow_type_id 
    else 
      d.fellow_type_id = 0
    end
     if d.email.present?  then
      d.email = d.email
    else
      d.email = ' '
    end
     if d.qualification.present?  then
      d.qualification = d.qualification
    else
      d.qualification = ' '
    end

     d.last_name =  row[4]
     d.country_id =  row[13].to_i
     d.organisation_id = row[5]
     d.specialty_id = row[8].to_i
     d.city_id = row[10]
     
   ret =   d.save!
 if ret == false then
 
 @errors < 'error inserting ' + d.last_name + ' ' + d.first_name
 end
    
end
end
	end

  return @errors
end

def maketransaction(table, tablename)
#sql ='DECLARE `_rollback` BOOL DEFAULT 0; '
#sql += 'DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1; '
#sql = "start transaction; " 
#sql += "DELETE FROM "  + tablename + "; "
 @set = ActiveRecord::Base.connection.execute("SET SESSION sql_mode='NO_AUTO_VALUE_ON_ZERO'");
 @res =  ActiveRecord::Base.connection.execute("DELETE FROM "  + tablename + "; ");
inserted = 0
@errors = Array.new
table.each_with_index do |row, ind|

	if ind > 0 then

sql = "insert into "  + tablename + "("
   table[0].each_with_index  do |colname, index| 
   	if index + 1 < table[0].count() then
   		sql +=  +colname + ","
   	else
   		sql +=  colname	
   	end
   end

sql += ") values("   
row.each_with_index  do |colvalue,index| 

	colvaluetested = ''
      if colvalue.is_a? Integer then

          colvaluetested = colvalue

       else
         colvaluetested = '"' + colvalue + '"' 
          
      end

   	if index + 1 < row.count() then
      
   		sql += colvaluetested.to_s + ','
   	else
   		sql += colvaluetested.to_s	
   	end
end

sql += '); '

begin
 res = ActiveRecord::Base.connection.execute(sql);
 inserted +=1;
rescue Exception => e
  inserted +=0;
   
  @errors << "#{e}"
end


end
end
 #sql +='IF `_rollback` THEN '
 #sql +=       'ROLLBACK; '
 #sql +=   'ELSE '
 #sql +=       'COMMIT; '
 #sql +=   'END IF; '    
  

return @errors;    
	end

end