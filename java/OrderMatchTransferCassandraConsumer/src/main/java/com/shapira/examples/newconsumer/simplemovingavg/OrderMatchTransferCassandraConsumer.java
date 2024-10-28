package com.shapira.examples.newconsumer.simplemovingavg;

import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.common.errors.WakeupException;
import org.json.JSONObject;

import com.datastax.oss.driver.api.core.CqlSession;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.time.Instant;
import java.util.Base64;
import java.util.Collections;
import java.util.Properties;
import com.datastax.oss.driver.api.core.cql.*;

public class OrderMatchTransferCassandraConsumer {

    private Properties kafkaProps = new Properties();
    // private String waitTime;
    private KafkaConsumer<String, String> consumer;

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("OrderMatchTransferCassandraConsumer {brokers} {group.id} {topic} {contactPoints} {port} {keyspace} {datacenter}");
            return;
        }
        final OrderMatchTransferCassandraConsumer movingAvg = new OrderMatchTransferCassandraConsumer();
        String brokers = args[0];
        String groupId = args[1];
        String topic = args[2];
        String contactPoints = args[3];
        int port = Integer.parseInt(args[4]);
        String keyspace = args[5];
        String datacenter = args[6];

        CassandraConfig cassandraConfig = CassandraConfig.getInstance(contactPoints,port,keyspace, datacenter);

        CqlSession session = cassandraConfig.getSession();

        movingAvg.configure(brokers, groupId);

        final Thread mainThread = Thread.currentThread();

        // Registering a shutdown hook so we can exit cleanly
        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                System.out.println("Starting exit...");
                // Note that shutdownhook runs in a separate thread, so the only thing we can safely do to a consumer is wake it up
                movingAvg.consumer.wakeup();
                try {
                    mainThread.join();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                if (cassandraConfig != null) {
                    cassandraConfig.close();
                }
                System.out.println("Closed consumer and we are done");
            }
        });

        try {
            movingAvg.consumer.subscribe(Collections.singletonList(topic));
            // todo open and move the last handled in database

            // looping until ctrl-c, the shutdown hook will cleanup on exit
            while (true) {
                ConsumerRecords<String, String> records = movingAvg.consumer.poll(1000);
                for (ConsumerRecord<String, String> record : records) {
                    // System.out.printf("offset = %d, key = %s, value = %s\n", record.offset(), record.key(), record.value());

                    String message = record.value();
                    
                    JSONObject jsonObj = new JSONObject(message);

                    JSONObject payload = jsonObj.getJSONObject("payload");
                    JSONObject after = payload.getJSONObject("after");
                    
                    try {
                        int match_id = after.getInt("match_id");
                        int buy_order_id = after.getInt("buy_order_id");
                        int sell_order_id = after.getInt("sell_order_id");
                        int asset_id = after.getInt("asset_id");
                        
                        BigDecimal price = parsePrice(after.get("price").toString());
                        BigDecimal quantity = parsePrice(after.get("quantity").toString());

                        Long trade_time = after.getLong("trade_time");
                        Instant itrade_time = Instant.ofEpochMilli(trade_time);
                        PreparedStatement preparedStatement = session.prepare(
                            "INSERT INTO order_matches (match_id, buy_order_id, sell_order_id, asset_id, price, quantity,trade_time) VALUES (?, ?, ?, ?, ?, ?,?)"
                        );
                        BoundStatement boundStatement = preparedStatement.bind(
                            match_id,buy_order_id,sell_order_id,asset_id,price,quantity,itrade_time
                        );
                        session.execute(boundStatement);
                        System.out.printf("order_matches saved offset %d match_id %d\n",record.offset(),match_id);
                    } catch (Exception e) {
                        e.printStackTrace();
                        System.out.printf("order_matches saving failure by offset %d\n",record.offset());
                    }

                }
                // for (TopicPartition tp: movingAvg.consumer.assignment())
                //     System.out.println("Committing offset at position:" + movingAvg.consumer.position(tp));
                movingAvg.consumer.commitAsync();
            }
        } catch (WakeupException e) {
            System.out.println("Error in consumer" + e.getMessage());
        } finally {
            try {
                movingAvg.consumer.commitSync();
            } finally {
                movingAvg.consumer.close();
                System.out.println("Closed consumer and we are done");
            }
        }
    }

    private void configure(String servers, String groupId) {
        kafkaProps.put("group.id",groupId);
        kafkaProps.put("bootstrap.servers",servers);
        kafkaProps.put("auto.offset.reset","earliest");         // when in doubt, read everything
        kafkaProps.put("key.deserializer","org.apache.kafka.common.serialization.StringDeserializer");
        kafkaProps.put("value.deserializer","org.apache.kafka.common.serialization.StringDeserializer");
        consumer = new KafkaConsumer<String, String>(kafkaProps);
    }

    private static BigDecimal parsePrice(String value) {
        byte[] decimalBytes = Base64.getDecoder().decode(value);
        BigInteger unscaledValue = new BigInteger(decimalBytes);
        BigDecimal bigDecimalPrice = new BigDecimal(unscaledValue, 8);
        return bigDecimalPrice;
    }

}
