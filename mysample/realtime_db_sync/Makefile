
MDB_URL=http://localhost:8081
NTF_URL=http://localhost:8080
USERNAME='user1'

m:
	vertx run    masterdb.rb -instance 2

n:
	vertx run    notifier.rb -instance 4

put:
	curl  --data-ascii 'values={"key1":"value1","key2":"value2"}' ${MDB_URL}/putValues?username=${USERNAME}

wait:
	curl  ${NTF_URL}/?username=${USERNAME}
