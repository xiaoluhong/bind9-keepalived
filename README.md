docker-bind9 
================
This project build a bind9 domain name server configured for the root domain $BIND9_ROOTDOMAIN env variable.

Use the following ENV when running :
- "BIND9_ROOTDOMAIN" : the root domain (like : example.com)
- "BIND9_KEYNAME" : the name of the key
- "BIND9_KEY" : the key


The port 53 must be exposed in tcp and udp to answer DNS requests. The port 953 must be open to enable DNS updates requests. This is very unsecure, because no key has been set.
Be sure to know what you are doing.

Run with :
sudo docker build -t docker-bind9 . && sudo docker run -p 53:53/udp -p 53:53 -p 953:953 --rm -it docker-bind9
