mvn clean package  
java -cp target/trading-ConsumerOrderMatchesToCassandra-1.0-SNAPSHOT.jar com.shapira.examples.newconsumer.simplemovingavg.OrderMatchTransferCassandraConsumer localhost:29092 g1 dbserver1.inventory.order_matches localhost 9042 guru_keyspace datacenter1
