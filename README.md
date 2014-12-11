One time pad in coffee script
=========

We have two computers called HostA and HostB, let's say that the ssh server is
on HostB. Let's say that out of the 100Mb key, we want to use the last 50Mb for
the server and the first 50Mb for the client.

On HostB we start the encryption server:
{% highlight bash %}
coffee receiver.coffee --localPort=8000 --servicePort=22 --serverOffset=52428800 --clientOffset=0
{% endhighlight bash %}
localPort,serverPort,clientOffset,serverOffset,host

On HostA we start the encryption client:
{% highlight bash %}
coffee sender.coffee --localPort=9000 --serverPort=8000 --host=HostB --serverOffset=52428800 --clientOffset=0
{% endhighlight bash %}

Then we can connect to HostB through the encryption tunnel with this command on HostA:
{% highlight bash %}
ssh localhost -p 9000
{% endhighlight bash %}

I also tried it with SCP and even an HTTP proxy and it worked fine!
Let me know what you think of it!
