select * from final_data order by playcount desc;

create table max_playcount_output(userid int, artistid int, playcount int)ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';



