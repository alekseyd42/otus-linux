#Set root password
alter user 'root'@'localhost' identified WITH mysql_native_password by 'password' ;
#allow root connection from network
update mysql.user set host='%' where user='root' and host='localhost';
