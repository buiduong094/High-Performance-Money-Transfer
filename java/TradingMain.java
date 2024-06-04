package test.tps.trading;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.apache.commons.cli.*;

public class TradingMain {
    private static int workers = 5;
    private static String module = "Tradings";

    public static void main(String[] args) {
        try {
            try (Connection conn = DBConnection.getInstance().getConnection()) {
                for (int i = 1;; i++) {
                    printInfor();
                    printAccInfors(conn);
                    printSumBaAccInfors(conn);
                    printOrders(conn);
                    printTps(conn, "trades", 10);
                    Thread.sleep(400);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void printInfor() {
        System.out.print("\033[H\033[2J");
        System.out.println("------------------------------");
        System.out.println("--------Threads        : " + workers);
        System.out.println("--------NumberAccounts : " + Configuration.NUMBER_ACCOUNTS);
        System.out.println("-------------------------------");
    }

    private static void printAccInfors(Connection conn) throws SQLException {
        String sql = "SELECT user_id, asset_id, balance FROM wallets limit ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, 15);
            try (ResultSet resultSet = statement.executeQuery()) {
                StringBuilder sb = new StringBuilder();
                sb.append("+-----------+-----------+--------------+\n");
                sb.append(String.format("|%9s  |%9s  |%14s|%n", "user_id", "asset_id", "Balance"));
                sb.append("+-----------+-----------+--------------+\n");

                while (resultSet.next()) {
                    sb.append(String.format("|%9s  |%9s  |%14s|%n", resultSet.getString("user_id"),
                            resultSet.getString("asset_id"), (resultSet.getLong("balance") + "")));
                }
                sb.append("+-----------------------+--------------+\n");

                System.out.print(sb.toString());
            }
        }
    }

    private static void printSumBaAccInfors(Connection conn) throws SQLException {
        String sql = "SELECT sum(balance) as total FROM wallets";

        try (PreparedStatement statement = conn.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                System.out.printf("|%21s  |%14s|%n", "Total", "" + resultSet.getLong("total"));
            }

            System.out.printf("+--------------------------------------+%n");
        }

        System.out.printf("%n%n");
        sql = "select status, count(order_id) as total from orders group by status;";

        try (PreparedStatement statement = conn.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            StringBuilder sb = new StringBuilder();
            sb.append("+------------------+-----------------+\n");
            sb.append("| status           | Total           |\n");
            sb.append("+------------------+-----------------+\n");

            while (resultSet.next()) {
                sb.append(String.format("|%18s|%14d   |%n", resultSet.getString("status"),
                        resultSet.getInt("total")));
            }
            sb.append("+------------------+-----------------+\n");

            System.out.print(sb.toString());
        }
    }

    private static void printOrders(Connection conn) throws SQLException {
        String sql = "select asset_symbol, order_type,price, quantity from assets, ( select asset_id, order_type,price, sum(quantity)-sum(filled_quantity) as quantity from orders where status <> 'filled' group by  price, order_type order by asset_id, price) x where assets.asset_id = x.asset_id";
        try (PreparedStatement statement = conn.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            StringBuilder sb = new StringBuilder();
            sb.append("+----------+------------+--------------+-----------------+\n");
            sb.append("| asset_id | order_type | price        | quantity        |\n");
            sb.append("+----------+------------+--------------+-----------------+\n");

            while (resultSet.next()) {
                sb.append(String.format("|%10s|%12s|%14s|%17s|%n",
                        resultSet.getString(1),
                        resultSet.getString(2),
                        resultSet.getInt(3),
                        resultSet.getInt(4)));
            }
            sb.append("+----------+------------+--------------+-----------------+\n");

            System.out.print(sb.toString());
        }
    }

    private static void printTps(Connection conn, String tableName, int seconds) throws SQLException {
        String sql = "SELECT trade_time, COUNT(trade_id) FROM trades "
                + "WHERE trade_time > SUBTIME(current_timestamp(), ?) " + "GROUP BY trade_time";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, "0 0:0:" + seconds + ".000000");
            try (ResultSet resultSet = statement.executeQuery()) {
                StringBuilder sb = new StringBuilder();
                sb.append("+-----------+----------+\n");
                sb.append(String.format("|%9s  |%10s|%n", "Time", "TPS"));
                sb.append("+-----------+----------+\n");

                while (resultSet.next()) {
                    Timestamp transactionDate = resultSet.getTimestamp("trade_time");
                    int transactionCount = resultSet.getInt("COUNT(trade_id)");
                    sb.append(String.format("|%9s  |%10s|%n", transactionDate.getSeconds(), transactionCount));
                }
                sb.append("+-----------+----------+\n");

                System.out.print(sb.toString());
            }
        }
    }

    public static void getCommand(String[] args) {
        Options options = new Options();
        options.addOption("module", "module", true, "Module Lock or NoLock");
        options.addOption("threads", "threads", true, "Number Of threads");
        options.addOption("lockName", "lockName", true, "Lock Name");
        options.addOption("thinkTime", "thinkTime", true, "Think Time");
        options.addOption("numberAccounts", "numberAccounts", true, "Number Account");
        options.addOption("dbName", "dbName", true, "Database Name");
        options.addOption("dbHost", "dbHost", true, "Database Host");
        options.addOption("dbPort", "dbPort", true, "Database Port");
        options.addOption("dbUser", "dbUser", true, "Database User");
        options.addOption("dbPassword", "dbPassword", true, "Database Password");

        CommandLineParser parser = new DefaultParser();
        try {
            CommandLine cmd = parser.parse(options, args);
            module = cmd.getOptionValue("module");
            if (cmd.hasOption("dbName"))
                Configuration.DB_NAME = cmd.getOptionValue("dbName");
            if (cmd.hasOption("dbHost"))
                Configuration.DB_HOST = cmd.getOptionValue("dbHost");
            if (cmd.hasOption("dbPort"))
                Configuration.DB_PORT = cmd.getOptionValue("dbPort");
            if (cmd.hasOption("dbUser"))
                Configuration.DB_USER = cmd.getOptionValue("dbUser");
            if (cmd.hasOption("dbPassword"))
                Configuration.DB_PASSWORD = cmd.getOptionValue("dbPassword");

            Configuration.LOCK_NAME = cmd.getOptionValue("lockName");
            if (cmd.hasOption("threads"))
                try {
                    workers = Integer.parseInt(cmd.getOptionValue("threads"));
                } catch (Exception e) {
                }
            if (cmd.hasOption("thinkTime"))
                try {
                    Configuration.THINK_TIME = Integer.parseInt(cmd.getOptionValue("thinkTime"));
                } catch (Exception e) {
                }
            if (cmd.hasOption("numberAccounts"))
                try {
                    Configuration.NUMBER_ACCOUNTS = Integer.parseInt(cmd.getOptionValue("numberAccounts"));
                } catch (Exception e) {
                }

            // Continue with processing...

        } catch (ParseException e) {
            System.err.println("Error: " + e.getMessage());
            System.exit(1);
        }
    }
}
