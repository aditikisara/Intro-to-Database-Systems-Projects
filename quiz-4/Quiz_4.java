// STEP: Import required packages
import java.sql.*;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.File;

public class Quiz_4 {
    private Connection c = null;
    private String dbName;
    private boolean isConnected = false;

    private void openConnection(String _dbName) {
        dbName = _dbName;

        if (false == isConnected) {
            System.out.println("++++++++++++++++++++++++++++++++++");
            System.out.println("Open database: " + _dbName);

            try {
                String connStr = new String("jdbc:sqlite:");
                connStr = connStr + _dbName;

                // STEP: Register JDBC driver
                Class.forName("org.sqlite.JDBC");

                // STEP: Open a connection
                c = DriverManager.getConnection(connStr);

                // STEP: Diable auto transactions
                c.setAutoCommit(false);

                isConnected = true;
                System.out.println("success");
            } catch (Exception e) {
                System.err.println(e.getClass().getName() + ": " + e.getMessage());
                System.exit(0);
            }

            System.out.println("++++++++++++++++++++++++++++++++++");
        }
    }

    private void closeConnection() {
        if (true == isConnected) {
            System.out.println("++++++++++++++++++++++++++++++++++");
            System.out.println("Close database: " + dbName);

            try {
                // STEP: Close connection
                c.close();

                isConnected = false;
                dbName = "";
                System.out.println("success");
            } catch (Exception e) {
                System.err.println(e.getClass().getName() + ": " + e.getMessage());
                System.exit(0);
            }

            System.out.println("++++++++++++++++++++++++++++++++++");
        }
    }

    private void createPriceRange() {
        System.out.println("++++++++++++++++++++++++++++++++++");
        System.out.println("Create PriceRange");


        System.out.println("++++++++++++++++++++++++++++++++++");
    }

    private void printPriceRange() {
        System.out.println("++++++++++++++++++++++++++++++++++");
        System.out.println("Print PriceRange");

        System.out.printf("%-10s %-20s %20s %20s\n",
            "maker", "product", "minPrice", "maxPrice");

        System.out.println("++++++++++++++++++++++++++++++++++");
    }

    private void insertPC(String _maker, int _model, double _speed,
        int _ram, int _hd, int _price) {
        System.out.println("++++++++++++++++++++++++++++++++++");
        System.out.printf("Insert PC (%s, %d, %3.1f, %d, %d, %d)\n",
            _maker, _model, _speed, _ram, _hd, _price);

        System.out.println("++++++++++++++++++++++++++++++++++");
    }

    private void updatePrinter(int _model, int _price) {
        System.out.println("++++++++++++++++++++++++++++++++++");
        System.out.printf("Update Printer (%d, %d)\n", _model, _price);

        System.out.println("++++++++++++++++++++++++++++++++++");
    }

    private void deleteLaptop(int _model) {
        System.out.println("++++++++++++++++++++++++++++++++++");
        System.out.printf("Delete Laptop (%d)\n", _model);

        System.out.println("++++++++++++++++++++++++++++++++++");
    }


    public static void main(String args[]) {
        Quiz_4 sj = new Quiz_4();
        
        sj.openConnection("data.sqlite");

        sj.createPriceRange();
        sj.printPriceRange();

        try {
            File fn = new File("input.in");
            FileReader reader = new FileReader(fn);
            BufferedReader in = new BufferedReader(reader);

            String line = null;
            while ((line = in.readLine()) != null) {
                System.out.println(line);

                String[] tok = line.split("[ ]");
                if (tok[0].equals(new String("I"))) {
                    sj.insertPC(tok[2], Integer.parseInt(tok[3]),
                        Double.parseDouble(tok[4]), Integer.parseInt(tok[5]),
                        Integer.parseInt(tok[6]), Integer.parseInt(tok[7]));
                }
                else if (tok[0].equals(new String("U"))) {
                    sj.updatePrinter(Integer.parseInt(tok[2]),
                        Integer.parseInt(tok[3]));
                }
                else if (tok[0].equals(new String("D"))) {
                    sj.deleteLaptop(Integer.parseInt(tok[2]));
                }

                sj.printPriceRange();
            }

            in.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }

        sj.closeConnection();
    }
}
