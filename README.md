<img src='https://github.com/junelsolis/freeradius-admin/blob/master/banner@2x.png' width="500">

A web interface for FreeRADIUS with a MySQL backend.


# Try the Demo Site
[https://fradmin-demo.junelsolis.com](https://fradmin-demo.junelsolis.com)

Login credentials: **admin**, **password**

# Install with Docker for Testing
The simplest way to install this app is using Docker.

1. Clone the master branch of this repository
2. Run ```cd freeradius-admin```
3. Run ```docker compose up```
4. Using your browser go to [http://localhost:80](http://localhost:80). The login credentials are **admin** and **password**.
5. To test radius server. Run ```radtest testuser password 0 testing123```.

# Production Setup
1. The folder *./mysql/src/data* must be emptied to prevent any conflicts with database passwords.
2. Edit [docker-compose.yml](docker-compose.yml). Change the ```MYSQL_ROOT_PASSWORD``` entry to your own password.
3. Edit [./web/src/.env](./web/src/.env) by changing the database settings to match the above.
3. Edit [./freeradius/config/freeradius/mods-enabled/sql](sql) with the correct database root password.
4. **IMPORTANT** Navigate to the *./web/src* directory and run the following code ```php artisan key:generate``` in order to generate an app key.
5. Build the images by running ```docker-compose build``` at the project root.
6. Run ```docker-compose up -d``` to run the services in the background.
7. Confirm the services are up ```docker container ps```.
9. **OPTIONAL:** Make *./generate-le.sh* executable ```chmod u+x generate-le.sh``` then run ```.generate-le.sh``` to generate a LetsEncrypt SSL certificate using standalone method. You may need to modify this script in order to work with your specific setup.


**mysql**

The **fradmin-mysql** container is configured with a generic username and password. This should be changed in the [docker-compose.yml](docker-compose.yml) file for production setups. The file [radius.sql](./mysql/srv/initdb.d/radius.sql) is a modified version of the radius MySQL schema included with [freeRADIUS](https://github.com/FreeRADIUS/freeradius-server) distributions. It is loaded by the container on startup if the database and tables do not already exist.

Furthermore, it is set to port-forward 3306 in case you need direct network access to the MySQL service. If this sort of access is not needed, it should be disabled in production setups by changing the 'port' declaration to 'expose'.

**freeradius 3.0.17**

The FreeRADIUS 3 server is the service around which the rest of the services in this app are built. You will need some knowledge about configuring it in order to make it work according to your requirements. The configuration files are located in the folder *./freeradius/config/freeradius*. This folder is volume-mapped to  As is, these files are ready to be deployed and will instantiate one virtual server called **server01** listening on the default auth and acct ports 1812 and 1813. Depending on your use case, you may wish to edit the *Simultaneous-Use* section of the [queries.conf](./freeradius/src/mods-config/sql/main/mysql/queries.conf) file.

**laravel**

For a production setup, modify the **.env** file located in *./web/src* and make sure **you change the app key** by going to a terminal, navigating to the *./web/src* directory, and running ```php artisan key:generate```.




# How to Contribute
Contributors are welcome. Fork the project and create a pull request. Please have a look at [CONTRIBUTING.md](CONTRIBUTING.md) for some guidelines.

# Project History
I originally started this project as a way to automate and simplify network user management at <a href="http://www.maxwellsda.org">Maxwell Adventist Academy</a>, a secondary school outside Nairobi, Kenya where I worked both as a physician and network administrator. I saw an interest in it because there was an opportunity to learn PHP/Laravel and configure FreeRADIUS at the same time. This was a challenge because the FreeRADIUS documentation does not seem very clear to beginners to the technology like me.

One of the things I found lacking was a GUI to manage users. There are some open source solutions out there, but I wanted one that was customized to our specific needs. And so this project was born, after having gone through a few iterations. With this repository, I am attempting to rewrite the application using Docker to help simplify development and deployment.
