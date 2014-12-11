One time pad in coffee script
=========

Assuming two hosts called HostA and HostB, and a ssh server on HostB. 
Out of the 100Mb key, we want to use the last 50Mb for the server and the first 50Mb for the client.

On HostB we start the encryption server:
```
  coffee receiver.coffee --localPort=8000 --servicePort=22 --serverOffset=52428800 --clientOffset=0
```

On HostA we start the encryption client:
```
  coffee sender.coffee --localPort=9000 --serverPort=8000 --host=HostB --serverOffset=52428800 --clientOffset=0
```

Then we can connect to HostB through the encryption tunnel with this command on HostA:
```
  ssh localhost -p 9000
```
I also tried it with SCP and even an HTTP proxy and it worked fine!
Let me know what you think of it!
