ALTER USER 'zhuzi' IDENTITY WITH mysql_native_password;

GRANT ALL ON *.* TO 'zhuzi'@'%';

FLUSH PRIVILEGES;