ALTER USER 'zhuzi' IDENTIFIED WITH mysql_native_password BY '123456';

GRANT ALL ON *.* TO 'zhuzi'@'%';

FLUSH PRIVILEGES;