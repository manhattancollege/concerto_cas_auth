Concerto CAS Auth
=====================

Authenticate Concerto users through your own [CAS](http://en.wikipedia.org/wiki/Central_Authentication_Service) deployment. 

Installing the plugin
----------------------
1. Log in using a system admin account in your Concerto deployment
2. Click on the "plugins" button on the top navigation bar under the admin section.
3. On the right side of the page, click on the "new plugin" button.
4. With RubyGems selected as the source, add the gem concerto_cas_auth in the text field. 
5. Click save, you will now stop your Concerto web server, run the ```bundle``` command, and start your web server again.
6. Since the CAS plugin is not configured yet, you can log back into your Concerto accounts by visiting the ```your.concerto.url/users/sign_in``` route. 
7. If the plugin was installed successfully, you will see a new CAS User Authentication settings tab under the "settings" page. This page can be found by clicking the "settings" button on the top navigation bar under the admin section.

Configuring the plugin
----------------------
1. Log in using a system admin account in your Concerto deployment
2. Click on the "settings" button on the top navigation bar under the admin section.
3. Click on the "CAS User Authentication" tab.
4. Configure the CAS URL to point towards your CAS deployment. For example, https://cas-auth.rpi.edu/cas. 
5. The CAS uid key will be used as a unique identifier for each account. This will be returned by your CAS server upon authentication.
6. The CAS email key is required and will be used to access the email address returned by your CAS server upon authentication.
7. After saving these settings, you will need to restart your Concerto web server.
8. Your log in links at the top of the page should now point to your CAS authentication. 
