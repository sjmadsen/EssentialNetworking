# Overview

This project contains the demo code for my Essential Cocoa Networking talk.
I've given this talk several times and it changes as I find new ways to
present the information and as Apple introduces new networking APIs.

If you happen to be looking for code from a particular conference, HEAD may
not match up with you want. Check the tags for a different point in the
history.

The slides are available on [Speaker Deck](https://speakerdeck.com/u/sjmadsen/p/essential-cocoa-networking).

There are several demos, each with server and client pieces.

# NSURLConnectionBasics

This is an iPad app showing off the basic features of NSURLConnection and how
to use them. It's mostly inteded to run in the simulator, but you can run it
on the device as long as you change the definition of HOST in Host.h to be the
DNS name or IP address of your Mac. The synchronous portion of this demo is
only useful when running on a device, outside of the debugger, otherwise the
watchdog is not active.

The server part for this demo is a Sinatra app. Sinatra is a small Ruby web
application framework. The demo works in Ruby 1.8.7 and 2.0, and should work
fine in 1.9.x. To install and run:

    $ bundle
    $ ruby basics-demo.rb

# FoundationOrAFN

This is an iPhone app demonstrating how many HTTP requests are more simply
done with AFNetworking than using NSURLConnection directly.

AFNetworking is referenced as a Git submodule, so you need to initialize it
before building the project:

    $ git submodule update --init --recursive

Use the same server for this app as for NSURLConnectionBasics.

# Performance

This is an iPhone app illustrating the performance gains you can get when
choosing various ways to access a network resource.

The client fetches simple static files for this demo. I had trouble with
pipelined requests using a Ruby server, so it's best if you use the Apache
that comes with Mac OS X. Copy apache.conf into /etc/apache2/other and restart
Apache with "sudo apachectl restart".

The best way to experience the differences between the different fetch styles
is to turn on the Network Link Conditioner and run the app on a device. If you
run in the simulator, you're using loopback networking, which bypasses the
NLC. On a device and without the NLC, you're likely on a good Wi-Fi network.
Neither of these environments is representative of what your users will
experience in the real world.
