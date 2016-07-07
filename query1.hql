create table user_artist(userid int, artistid int, playcount int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ' ';

load data local inpath 'Downloads/user_artist_data.txt' into table user_artist_data;

create table artist_data(artistid int, artist_name string) ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe' WITH SERDEPROPERTIES ("input.regex"="([0-9]*)\\s+([^\"]*)");

load data local inpath 'Downloads/artist_data.txt' into table artist_data;

create table artist_alias(artistid int, canonical_artistid int) ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe' WITH SERDEPROPERTIES ("input.regex"="([0-9]*)\\s+([0-9]*)");

load data local inpath 'Downloads/artist_alias.txt' into table artist_alias;

create view user_joined as select ua.userid, ua.artistid, ua.playcount, al.canonical_artistid from user_artist ua LEFT OUTER JOIN artist_alias al ON (ua.artistid=al.artistid);

create table final_data(userid int, artistid int, playcount int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

insert overwrite table final_data select userid, canonical_artistid, playcount from user_joined where canonical_artistid is NOT NULL;

insert into table final_data select userid, artistid, playcount from user_joined where canonical_artistid is NULL;








