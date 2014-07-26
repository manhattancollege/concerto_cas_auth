Concerto RPI CAS Auth
=====================

Modified [Concerto CAS Auth plugin](https://github.com/concerto/concerto_cas_auth) for the RPI Concerto deployment. Since RPI CAS servers don't return extra details, this plugin builds user email addresses based on the uid returned by CAS and gets extra information through the RPI LDAP servers. 
