Realtime db sync sample
=======================

## Concept

I want to synchronize local DBs.
I think it can be done to implement the cloud based storage system 
and realtime notifier.


## Architecture

  sever: (in the cloud)
             [db]                [notifier]
        "<key1>, <value1>"
        "<key2>, <value2>"
  
  
  client1:
        "<key1>, <value1>"
        "<key2>, <value2>"
  
  
  client2:
        "<key1>, <value1>"
        "<key2>, <value2>"


1. if the client1 get "<key3>, <value3>", client1 post to server.
   server will notify the information to all clients.

  client1:
        "<key1>, <value1>"
        "<key2>, <value2>"
        "<key3>, <value3>" <= new record!

            |
            |  post
            v
  server:
        "<key3>, <value3>" <= new record!
          
            |
            |  notify
            v
  client1:, client2:


2. each client fetch lists from the server
   and update local DB of each client.

  server:
            |
            |  fetch list (key1,key2,key3)
            v
  client2:
        "<key1>, <value1>"
        "<key2>, <value2>"
        "<key3>, <value3>" <= new record!


## Long polling notifier

"long polling" is technique to archive the http based push notify.
It can be use https and can be connect over ordinary http proxy servers.

Notifier of this system use "Chunked_transfer_encoding" for it.

1. client connects to nitifier server.
   client1 will wait for server's response 60 seconds.

   server:
            ^
            |  connect (blocking 60 seconds)
            |
   client1:

2. If server doesn't have any notify event on 60 seconds, 
   server will reply 200 OK to the client.

   server:
            |
            |  200 OK ( without any notify )
            v
   client1:

3. If server want to push a notify event,
   server replies the event on http chunked body.

   server:
            |
            |  Notify ( chunked http response body )
            v
   client1:



