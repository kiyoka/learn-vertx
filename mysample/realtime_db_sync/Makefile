
MDB_URL=http://localhost:8081
NTF_URL=http://localhost:8080

m:
	vertx run masterdb.rb

n:
	vertx run notifier.rb

put:
	curl  --data-ascii 'values={"key1":"value1","key2":"value2"}' ${MDB_URL}/putValues

wait:
	curl  ${NTF_URL}/ 


