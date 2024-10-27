# High-Performance Money Transfer Application

Welcome to the High-Performance Money Transfer Application repository! This application is designed to handle money transfers between accounts with a high transactions per second (TPS) rate, ensuring consistency and reliability in a concurrent environment.

## Features

- **High TPS**: Optimized to achieve high transactions per second (2000 TPS) with a balanced load on the system.
- **Consistency**: Ensures data consistency using database transactions and caching mechanisms.
- **Scalability**: Uses multi-threading (worker threads) to handle concurrent transactions efficiently.

## Technologies Used

- **Java**: Java running to show the account information and TPS information.
- **MySQL**: SQL database for storing account information and transfer information.
- **Golang Worker Threads**: Golang worker threads for handling concurrent processing.

## Hardware Requirements

To achieve optimal performance, the following hardware configuration is recommended:

- **CPU**: Multi-core processor (4 cores or more recommended)
- **RAM**: Minimum 8 GB (16 GB recommended)
- **Disk**: SSD with at least 100 GB of free space
- **Network**: N/A


### Example Configuration

- **Processor**: M1
- **Memory**: 16 GB
- **Storage**: 256 GB NVMe SSD
- **Network**: N/A

## Getting Started

### Prerequisites

Ensure you have the following installed:

- java version "1.8.0_291"
- go version go1.22.2 darwin/arm64
- mysql  Ver 8.1.0 for macos13.3 on arm64

### Installation

1. **Clone the repository**

    ```bash
    git clone https://github.com/buiduong094/High-Performance-Money-Transfer.git
    cd high-performance-money-transfer
    ```

2. **Install dependencies**

    ```bash
        go build .
    ```

3. **Configure MySQL**

    Make sure your MySQL is running and accessible. Update the connection strings in the code if necessary.

### Running the Application

1. **Start the application**

    ```bash
        java -jar tps.jar
    ```

    The application will start processing transactions immediately.

### Running Performance Tests

1. **Execute the performance test script**

    ```bash
        go run .
    ```

    This script will perform a predefined number of transactions and calculate the TPS.

    **Output Example 1**:

```
-------------------------------
--------Threads        : 5
--------NumberAccounts : 10
-------------------------------
------------------------
|  Account  |   Balance|
------------------------
|   ACCT-1  |   6661.98|
|   ACCT-2  |   1231.54|
|   ACCT-3  |   8015.78|
|   ACCT-4  |   8572.28|
|   ACCT-5  |   5164.06|
|   ACCT-6  |    792.46|
|   ACCT-7  |    7531.1|
|   ACCT-8  |   8702.15|
|   ACCT-9  |    222.43|
|  ACCT-10  |   3240.73|
|  ACCT-11  |   8877.33|
------------------------
|    Total  |  59011.84|
------------------------

------------------------
|  Time(s)  |       TPS|
------------------------
|       11  |      2318|
|       12  |      2353|
|       13  |      2369|
|       14  |      2343|
|       15  |      2353|
|       16  |      2357|
|       17  |      2330|
|       18  |      2257|
|       19  |      2251|
|       20  |      1879|
------------------------
```

***Run again***
```
-------------------------------
--------Threads        : 5
--------NumberAccounts : 10
-------------------------------
------------------------
|  Account  |   Balance|
------------------------
|   ACCT-1  |   6131.98|
|   ACCT-2  |   1864.54|
|   ACCT-3  |   7418.78|
|   ACCT-4  |   8269.28|
|   ACCT-5  |   5195.06|
|   ACCT-6  |    325.46|
|   ACCT-7  |    7325.1|
|   ACCT-8  |   9100.15|
|   ACCT-9  |   1717.43|
|  ACCT-10  |   2786.73|
|  ACCT-11  |   8877.33|
------------------------
|    Total  |  59011.84|
------------------------

------------------------
|  Time(s)  |       TPS|
------------------------
|       50  |      2313|
|       51  |      2311|
|       52  |      2384|
|       53  |      2337|
|       54  |      2338|
|       55  |      2284|
|       56  |      2342|
|       57  |      2428|
|       58  |      2336|
|       59  |      1562|
------------------------
```
This output indicates that the application processed transactions numerous times, yet the total balance remained unchanged despite high TPS. The TPS was calculated using group by second function in MySQL.

## Project Structure

- `run.go`: Entry point for the application, initializes worker threads for concurrent processing.
- `transfer.go`: Contains the main logic for transferring money between accounts.
- `models/`: Contains MySQL schema definitions for accounts and transfers.

## How It Works

### Transaction Logic

The core functionality of the application is in the `transferMoney` function which:

1. .....
2. .....

### Performance Optimization

- **Worker Threads**: Multiple worker threads are used to process transactions in parallel, increasing the throughput.

## Trading Modules

### Design

<img alt="Desgin" src="https://raw.githubusercontent.com/buiduong094/High-Performance-Money-Transfer/main/images/trading.png">
### Scale the design:
<img alt="Scale Design" src="https://raw.githubusercontent.com/buiduong094/High-Performance-Money-Transfer/main/images/trading-detail.png">

```
---------------------------------
--------Threads        : 5
--------Module         : Tradings
---------------------------------
+-----------+-----------+--------------+
|  user_id  | asset_id  |       Balance|
+-----------+-----------+--------------+
|        1  |        1  |     100017908|
|        1  |        2  |     100006904|
|        1  |        3  |      97518728|
|        2  |        1  |     100001836|
|        2  |        2  |      99993710|
|        2  |        3  |     100440579|
|        3  |        1  |     100001697|
|        3  |        2  |      99991176|
|        3  |        3  |     100700310|
|        4  |        1  |      99978559|
|        4  |        2  |     100008210|
|        4  |        3  |     101340383|
+-----------------------+--------------+
|                Total  |    1200000000|
+--------------------------------------+

+------------------+-----------------+
| status           | Total           |
+------------------+-----------------+
|              open|           379   |
|  partially_filled|            84   |
|            filled|         44765   |
+------------------+-----------------+

+----------+------------+--------------+-----------------+
| asset_id | order_type | price        | quantity        |
+----------+------------+--------------+-----------------+
|       1  |         buy|           100|            17649|
|       1  |        sell|           101|             4270|
+----------+------------+--------------+-----------------+

+-----------+----------+
|  Time(s)  |       TPS|
+-----------+----------+
|        0  |       378|
|        1  |       412|
|        2  |       411|
|        3  |       395|
|        4  |       398|
|        5  |       368|
|        6  |       390|
|        7  |       378|
|        8  |       364|
|        9  |        43|
+-----------+----------+
```

## Contributing

We welcome contributions from the community! Please feel free to submit a pull request or open an issue to discuss improvements, bug fixes, or new features.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or suggestions, please open an issue or contact us at [buiduong094@gmail.com](mailto:buiduong094@gmail.com).

---

Thank you for using the High-Performance Money Transfer Application! We hope it meets your needs and helps you achieve high efficiency in your money transfer operations. Happy coding!

---
