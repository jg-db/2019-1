load data
 infile '...\test.csv'
 APPEND
 into table xx_test
 fields terminated by ","		  
 ( name, surname, email, status, creation_date )