Concerto CAS Auth
=====================

Authenticate Concerto users through your own [CAS](http://en.wikipedia.org/wiki/Central_Authentication_Service) deployment. 

Installation Instructions
=========================

To include configuration options specific to your CAS server, please run the following command once your ```bundle``` command successfully completes:

``` rake concerto_cas_auth:install ```

This command will copy a file called ```concerto_cas_auth.yml``` into the main Concerto application files under ```config/initializers/```. 

The following options must be edited: ```host``` and ```url```
The rest are optional, but could be needed if your CAS host uses different keys when returning extra details. Concerto requires that the uid_key, email_key, and first_name_key are specified in order to validate and create a new user model. 
