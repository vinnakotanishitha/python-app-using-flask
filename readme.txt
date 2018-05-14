 /$$      /$$                       /$$
| $$$    /$$$                      | $$
| $$$$  /$$$$  /$$$$$$   /$$$$$$  /$$$$$$
| $$ $$/$$ $$ |____  $$ /$$__  $$|_  $$_/
| $$  $$$| $$  /$$$$$$$| $$  \__/  | $$
| $$\  $ | $$ /$$__  $$| $$        | $$ /$$
| $$ \/  | $$|  $$$$$$$| $$        |  $$$$/
|__/     |__/ \_______/|__/         \___/


This a simple mart website which connects to postgresql database to store data and python to compute and display as well as to connect.

Tables are created in the public schema of mydb database.

Tables in the database:
zztemp_checkout
zztemp_checkout_item_details
zztemp_customers
zztemp_employees
zztemp_inventory
zztemp_items
zztemp_paytype
zztemp_store

Modules used in python:
Connection to postgres: psycopg2
Webserver and processing framework: Flask

Installation instructions:
1. Install python3.5 from https://www.python.org/downloads/windows/
2. Install pip using the command - "python get-pip.py"
  Note: get-pip.py is included in the files
3. Upon installing pip, use below commands to install psycopg2
  Installation for psycopg2 module: "pip install psycopg2"
  Alternatively refer to http://flask.pocoo.org/docs/0.11/installation/#windows-easy-install
  and download psycopg2 from http://www.stickpeople.com/projects/python/win-psycopg/
4. Installation for flask: "pip install flask"
This concludes the installation section

Now, run the following command to start the web server:
  python main.py

This starts up a simple web-server with access to port 5000 to prevent admin conflicts.
Please visit http://localhost:5000 to get started.
To remove debug mode, change
if __name__ == "__main__":
    app.run(debug = True)

at the end of main.py file to
if __name__ == "__main__":
    app.run()


The details for routing the paths is given in main.py file
Database connection details are present in dbconnect.py file
Table details and initial data to be included is given in db_script.sql file.
