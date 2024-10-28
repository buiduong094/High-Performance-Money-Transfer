##run sh file: 
```
./run_new_consumer.sh
```

##The insert command in mysql:
```
INSERT INTO inventory.order_matches
( buy_order_id, sell_order_id, asset_id, price, quantity, trade_time)
VALUES(10002, 10001, 1, 5.00000000, 6.00000000, now());
```
##The data in mysql: 
```select * from order_matches om order by match_id desc```

```
match_id|buy_order_id|sell_order_id|asset_id|price     |quantity  |trade_time         |
--------+------------+-------------+--------+----------+----------+-------------------+
      76|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:06:35|
      75|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:06:35|
      74|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:06:34|
      73|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:06:33|
      72|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:06:25|
      71|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:06:24|
      70|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:06:24|
      69|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:06:23|
      68|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:06:20|
      67|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:04:04|
      66|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:45|
      65|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:21|
      64|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:21|
      63|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:21|
      62|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:21|
      61|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:21|
      60|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:20|
      59|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:20|
      58|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:20|
      57|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:20|
      56|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:20|
      55|       10002|        10001|       1|5.00000000|6.00000000|2024-10-28 13:03:19|
```


##the logs by the service: 
```
order_matches saved offset 67 match_id 68
order_matches saved offset 68 match_id 69
order_matches saved offset 69 match_id 70
order_matches saved offset 70 match_id 71
order_matches saved offset 71 match_id 72
order_matches saved offset 72 match_id 73
order_matches saved offset 73 match_id 74
order_matches saved offset 74 match_id 75
order_matches saved offset 75 match_id 76
```

##The data in cassandra:
```
 asset_id | match_id | buy_order_id | price      | quantity   | sell_order_id | trade_time
----------+----------+--------------+------------+------------+---------------+---------------------------------
        1 |       55 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:19.000000+0000
        1 |       56 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:20.000000+0000
        1 |       57 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:20.000000+0000
        1 |       58 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:20.000000+0000
        1 |       59 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:20.000000+0000
        1 |       60 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:20.000000+0000
        1 |       61 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:21.000000+0000
        1 |       62 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:21.000000+0000
        1 |       63 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:21.000000+0000
        1 |       64 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:21.000000+0000
        1 |       65 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:21.000000+0000
        1 |       66 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:03:45.000000+0000
        1 |       67 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:04:04.000000+0000
        1 |       68 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:06:20.000000+0000
        1 |       69 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:06:23.000000+0000
        1 |       70 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:06:24.000000+0000
        1 |       71 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:06:24.000000+0000
        1 |       72 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:06:25.000000+0000
        1 |       73 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:06:33.000000+0000
        1 |       74 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:06:34.000000+0000
        1 |       75 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:06:35.000000+0000
        1 |       76 |        10002 | 5.00000000 | 6.00000000 |         10001 | 2024-10-28 13:06:35.000000+0000
```


##Reference:
https://github.com/gwenshap/kafka-examples/tree/master/SimpleMovingAvg