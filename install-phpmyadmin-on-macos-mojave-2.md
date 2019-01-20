With Apples' new macOS Mojave 10.14 available for download, here is how
to get the **AMP** stack up and running on the new macOS. This
tutorial** **will go through the process of getting **Apache, MySQL,
PHP** (or otherwise known as the 'AMP'
stack)** and **phpMyAdmin** running on the new mac OS Mojave.

This tutorial sets up the AMP stack in more of a traditional way using
the loaded Apache and PHP and downloading MySQL and phpMyAdmin.


[Apache/WebSharing]
----------------------------------

Web serving is built into Mojave with **Apache** app, it is installed
ready to be fired up.

This needs to be done in the **Terminal** which is found in the OS
filing system at **/Applications/Utilities/Terminal**

For those not familiar with the Terminal, it really isn't as
intimidating as you may think, once launched you are faced with a
command prompt waiting for your commands -- just type/paste in a command
and hit enter, some commands give you no response -- it just means the
command is done, other commands give you feedback.

Using the prefix of *sudo* is required for commands that have their
applications protected in specific folders -- when using *sudo* you will
need to confirm with your **admin** password or **iCloud** password if
set up that way.... let's get to it ...

to start Apache web sharing

``` {.crayon:false}
sudo apachectl start
```

to stop it

``` {.crayon:false}
sudo apachectl stop
```

to restart it

``` {.crayon:false}
sudo apachectl restart
```

To find the Apache version

``` {.crayon:false}
httpd -v
```

The Apache version that comes in macOS Mojave is **Apache/2.4.34     
  **


After starting **Apache** -- test to see if the webserver is working in
the browser -- http://localhost -- you should see the "It Works!" text.

If you don't get the localhost test, you can try troubleshooting Apache
to see if there is anything wrong in its config file by running

``` {.crayon:false}
apachectl configtest
```

This will give you an indication of what might be wrong.

[Document Root]
------------------------------

Document root is the location where the files are shared from the file
system and is similar to the traditional names of '**public\_html**' and
'**htdocs**', macOS has historically had 2 web roots one at a system
level and one at a user level -- you can set both up or just run with
one, the user level one allows multiple accounts to have their own web
root whilst the system one is global for all users. It seems there is
less effort from Apple in continuing with the user level one but it
still can be set up with a couple of extra tweaks in configuration
files. It is easier to use the user level one as you don't have to keep
on authenticating as an admin user.

### System Level Web Root

-- the default system document root is still found at --

**http://localhost/**

The files are shared in the filing system at --

``` {.crayon:false}
/Library/WebServer/Documents/
```

### User Level Root {#userlevel .mainhead}

The other web root directory which is missing by default is the
'**\~/Sites'** folder in the User account. This takes a bit longer to
set up but some users are very accustomed to using it.

You need to make a "**Sites**" folder at the root level of your account
and then it will work. Once you make the Sites folder you will notice
that it has a unique icon which is a throwback from a few versions
older. Make that folder before you set up the user configuration file
described next.

You have to make a few additional tweaks to get the **\~/Sites** folder
back up and running.

Add  a "username.conf" filed under:

``` {.crayon:false}
/etc/apache2/users/
```

If you don't already have one (very likely), then create one named by
the short username of the account with the suffix **.conf**, its
location and permissions/ownership is best tackled by using the
**Terminal**, the text editor '**nano**' would be the best tool to deal
with this.

Launch **Terminal**, (Applications/Utilities), and follow the commands
below, first one gets you to the right spot, 2nd one opens the text
editor on the command line (swap '**username**' with your account's
shortname, if you don't know your account shortname type '*whoami*' the
Terminal prompt):

``` {.crayon:false}
cd /etc/apache2/users
```

``` {.crayon:false}
sudo nano username.conf
```

Then add the content below **swapping** in your '**username' **in the
code below:

``` {.crayon:false}
<Directory "/Users/username/Sites/">
AllowOverride All
Options Indexes MultiViews FollowSymLinks
Require all granted
</Directory>
```

Permissions on the file should be:

``` {.crayon:false style="margin-top: 0px; outline: 0px; margin-bottom: 22px !important; padding: 11px !important; border: 1px solid #dadada !important; font-size: 12px !important; background-image: none !important; background-attachment: scroll !important; background-color: #f0f0f0 !important; font-family: Consolas, Monaco, 'Courier New', Courier, monospace !important; overflow-x: auto !important; word-wrap: break-word !important; line-height: 1.3em !important; background-position: 0px 0px !important; background-repeat: repeat repeat !important;"}
-rw-r--r--   1 root  wheel  298 Jun 28 16:47 username.conf
```

If not you need to change...

``` {.crayon:false}
sudo chmod 644 username.conf
```

Open the main **httpd.conf** and allow some modules:

``` {.crayon:false}
sudo nano /etc/apache2/httpd.conf
```

And make sure these modules are uncommented (the first 2 should already
be on a clean install):

``` {.crayon:false}
LoadModule authz_core_module libexec/apache2/mod_authz_core.so
```

``` {.crayon:false}
LoadModule authz_host_module libexec/apache2/mod_authz_host.so
```

``` {.crayon:false}
LoadModule userdir_module libexec/apache2/mod_userdir.so
```

``` {.crayon:false}
LoadModule include_module libexec/apache2/mod_include.so
```

``` {.crayon:false}
LoadModule rewrite_module libexec/apache2/mod_rewrite.so
```

 

While you have this file open also to get php running, uncomment the
below ... (Mentioned also in the PHP part of the article).

``` {.crayon:false}
LoadModule php7_module libexec/apache2/libphp7.so
```

And also uncomment this configuration file also in **httpd.conf --**
*which allows user home directories.*

``` {.crayon:false}
Include /private/etc/apache2/extra/httpd-userdir.conf
```

Save all your changes (Control + O in *nano*)

Then open *another* Apache config file and uncomment another file:

``` {.crayon:false}
sudo nano /etc/apache2/extra/httpd-userdir.conf
```

And uncomment:

``` {.crayon:false}
Include /private/etc/apache2/users/*.conf
```

Save all your changes (Control + O in *nano*)

 

Restart Apache for the new file to be read:

``` {.crayon:false}
sudo apachectl restart
```

Then this user level document root will be viewable at:

**http://localhost/\~username/**

You should only see a directory tree like structure if the folder is
empty.


[Override .htaccess and allow URL Rewrites]
----------------------------------------------------------

If you are going to use the web serving *document root* at
/Library/WebServer/Documents it is a good idea to allow any
**.htaccess** files used to override the default settings -- this can be
accomplished by editing the **httpd.conf** file at line 217 and setting
the **AllowOverride** to **All** and then restart Apache. This is
already taken care of at the Sites level webroot by following the
previous step.

``` {.crayon:false}
sudo nano /etc/apache2/httpd.conf
```

 


osx-htaccess-override
:::

Also while here allow URL **rewrites** so your permalinks look clean,
not ugly.

Uncomment in httpd.conf -- *should be uncommented on a clean instal*l.

``` {.crayon:false}
LoadModule rewrite_module libexec/apache2/mod_rewrite.so
```

 

[PHP](#ssu){.scroll} {#php .mainhead}
--------------------

**PHP 7.1.9**  is loaded in this version of macOS Mojave and needs to be
turned on by uncommenting a line in the **httpd.conf** file.

``` {.crayon:false}
sudo nano /etc/apache2/httpd.conf
```

Use "control" + "w" to search within **nano** and search for 'php' this
will land you on the right line then uncomment the line (remove the \#):

``` {.crayon:false}
LoadModule php7_module libexec/apache2/libphp7.so
```

Write out and Save using the nano shortcut keys at the bottom 'control
o' and 'control x'

Reload Apache to kick in

``` {.crayon:false}
sudo apachectl restart
```

To see and test PHP, create a file name it "phpinfo.php" and file it in
your document root with the contents below, then view it in a browser.

``` {.crayon:false}
 <?php phpinfo(); ?>
```

[MySQL]
----------------------

MySQL doesn't come pre-loaded with macOS Mojave and needs to
be [dowloaded from the MySQL
site](http://dev.mysql.com/downloads/mysql/).

The latest version of **MySQL 8.0.12** does work with the public release
of macOS.

Use the **macOS 10.13 (x86, 64-bit), DMG Archive **version (works on
macOS Mojave).

If you are upgrading from a previous macOS and have an older MySQL
version you do not have to update it.

Also if you have a clean install and want the earlier MySQL version 5.7,
you can still get this from the MySQL site -- from the 'Looking for
previous GA versions' link. (MySQL 8 is relatively new and not in many
production set ups)

One thing with MySQL upgrades, always take a [data dump of your
database](https://coolestguidesontheplanet.com/import-export-mysql-database-command-line/ "Import / Export a mysql database on the command line")
in case things go south and before you upgrade to macOS Mojave make sure
your MySQL Server is **not** running.

When downloading you don't have to sign up, look for **[» No thanks,
just take me to the downloads!]{style="background-color: #ffff00;"}** 
-- go straight to the download mirrors and download the software from a
mirror which is closest to you.

Once downloaded open the **.dmg** and run the installer.

During the MySQL process you are prompted to choose between strong and
legacy password encryptions, since version 8 is entirely new, some
software like phpMyAdmin can't connect with the newer encryptions -- so
if you are going to use a GUI wrapper like phpMyadmin I suggest you
stick to **legacy**.


Then add a password for the MySQL root user.


### Add Mysql to your path

After installation, in order to use **MySQL** commands without typing
the full path to the commands you need to add the [mysql directory to
your shell
path](https://coolestguidesontheplanet.com/add-shell-path-osx/ "What it is and How to Modify the Shell Path in OSX 10.10 Yosemite using Terminal"),
(optional step) this is done in your ".bash\_profile" file in your home
directory, if you don't have that file just create it using vi or nano:

``` {.crayon:false}
cd ; nano .bash_profile
```

``` {.crayon:false}
export PATH="/usr/local/mysql/bin:$PATH"
```

The first command brings you to your home directory and opens
the .bash\_profile file or creates a new one if it doesn't exist, then
add in the line above which adds the MySQL binary path to commands that
you can run. Exit the file with type "control + x" and when prompted to
save the change by typing "y". The last thing to do here is to reload
the shell for the above to work straight away.

``` {.crayon:false}
source ~/.bash_profile
```

### 

### Change the MySQL root password

(This section is left in for reference -- in previous macOS MySQL
packages the password set during the installation process would fail --
hence the info below. This newer version, however, seems to work).

Note that this is not the same as the root or admin password of macOS --
this is a unique password for the **MySQL root user**.

Stop MySQL

    sudo /usr/local/mysql/support-files/mysql.server stop

Start it in safe mode:

    sudo mysqld_safe --skip-grant-tables

This will be an ongoing command until the process is finished **so open
another shell/terminal window**, and log in without a password as
*root*:

``` {data-initialized="true" data-gclp-id="2"}
mysql -u root
```

    FLUSH PRIVILEGES;

    ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';

Change the lowercase **'MyNewPass'** to what you want -- and **keep**
the single quotes.

    \q

Start MySQL

    sudo /usr/local/mysql/support-files/mysql.server start

Starting MySQL
--------------

You can then start the MySQL server from the **System Preferences** or
via the **command line.**

The new MySQL system preference also has the uninstall feature -- useful
if you've installed it with a security encryption that's not working for
you and want to try the other one. You can also see the paths to the
config and data sources of MySQL in the configuration tab.

 

Or to Command line start MySQL.

``` {.crayon:false}
sudo /usr/local/mysql/support-files/mysql.server start
```

To find the MySQL version from the terminal, type at the prompt:

``` {.crayon:false}
/usr/local/mysql/bin/mysql -v -uroot -p
```

This also puts you into a *shell* interactive dialogue with MySQL, type
\\q to exit.

 

###  {#password}

###  {#section-4}

### Fix the 2002 MySQL Socket error {#password}

Fix the looming 2002 socket error -- which is linking where MySQL places
the socket and where macOS thinks it should be, MySQL puts it in
**/tmp** and macOS looks for it in **/var/mysql** the socket is a type
of file that allows MySQL client/server communication.

``` {.crayon:false}
sudo mkdir /var/mysql
```

``` {.crayon:false}
sudo ln -s /tmp/mysql.sock /var/mysql/mysql.sock
```

###  {#section-5}

[phpMyAdmin]
---------------------------

First fix the *2002 socket error* if you haven't done so from the MySQL
section-

``` {.crayon:false}
sudo mkdir /var/mysql
```

``` {.crayon:false}
sudo ln -s /tmp/mysql.sock /var/mysql/mysql.sock
```

Download [phpMyAdmin](http://www.phpmyadmin.net/home_page/downloads.php "phpmyadmin download"),
the zip English package will suit a lot of users, then unzip it and move
the folder with its contents into the document root level renaming
folder to 'phpmyadmin'.

Make the **config** folder

``` {.crayon:false}
mkdir ~/Sites/phpmyadmin/config
```

Change the permissions

``` {.crayon:false}
chmod o+w ~/Sites/phpmyadmin/config
```

Run the set up in the browser

**http://localhost/\~username/phpmyadmin/setup/ **or** http://localhost/phpmyadmin/setup/**

**![](/wp-content/uploads/2013/08/phpmyadmin-set-new-server.png)**

You need to create a
new [localhost ]{style="line-height: 1.538em;"}[mysql server connection,
click **new server**.]{style="line-height: 1.538em;"}

 

![](/wp-content/uploads/2013/08/phpmyadmin-set-new-server-mysql-password.png)\
Switch to the **Authentication** tab and set the local MySQL root user
and the password.\
Add in the username "root" (maybe already populated, add in the password
that you set up **[earlier](#password)** for the MySQL root user set up,
click on save and you are returned to the previous screen.\
(This is not the macOS Admin or root password -- it is the MySQL root
user)

 

[Now going to http://localhost/\~username/phpmyadmin/ will now allow you
to interact with your MySQL databases.]{style="line-height: 1.538em;"}

![](/wp-content/uploads/2013/08/phpmyadmin-4-no-frames.png)

 

[Permissions]
----------------------------

To run a website with no permission issues it is best to set the web
root and its contents to be writeable by all since it's a local
development it shouldn't be a security issue.

Let's say that you have a site in the **User Sites** folder at the
following location **\~/Sites/testsite** you would set it to be
writeable like so:

``` {.crayon:false}
sudo chmod -R a+w ~/Sites/testsite
```

If you are concerned about security then instead of making it world
writeable you can set the owner to be Apache **\_www** but when working
on files you would have to authenticate more as admin you are "not" the
owner, you would do this like so:

``` {.crayon:false}
sudo chown -R _www ~/Sites/testsite
```

This will set the contents recursively to be owned by the Apache user.

If you had the website stored at the **System** level Document root at
say **/Library/WebServer/Documents/testsite** then it would have to be
the latter:

``` {.crayon:false}
sudo chown -R _www /Library/WebServer/Documents/testsite
```

Another more straightforward way to do this if you have a one user
workstation is to change the [Apache web user from \_www to your
account](https://coolestguidesontheplanet.com/install-apache-mysql-php-on-macos-mojave-10-14/#permissions).

That's it! You now have the native AMP stack running on top of macOS
Mojave.

