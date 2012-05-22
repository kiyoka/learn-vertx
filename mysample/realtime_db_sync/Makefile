
MDB_URL=http://localhost:8081
NTF_URL=http://localhost:8080
USERNAME_A='userA'
USERNAME_B='userB'

m:
	vertx run    masterdb.rb -instance 2

n:
	vertx run    notifier.rb -instance 4


insertA1:
	curl  --data-ascii 'kv={"1337697112:6f96cfdfe5ccc627cadf24b41725caa4" : "hello"}'  ${MDB_URL}/insertValue?username=${USERNAME_A}

insertA2:
	curl  --data-ascii 'kv={"1337697249:e358efa489f58062f10dd7316b65649e" : "Vert.x"}' ${MDB_URL}/insertValue?username=${USERNAME_A}

syncA:
	ruby clientdb.rb  ${USERNAME_A}

syncB:
	ruby clientdb.rb  ${USERNAME_B}

insertB1:
	curl  --data-ascii 'kv={"1337697513:e358efa489f58062f10dd7316b65649e" : "World"}' ${MDB_URL}/insertValue?username=${USERNAME_B}
