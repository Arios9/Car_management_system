
package car_management_system;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBConection_MYSQL {
    
    private static final String link="jdbc:mysql://dblabs.it.teithe.gr:3306/it164826";
    private static final String username="it164826";
    private static final String password="707577";
    
    public static Connection get_MyDBConnection() throws SQLException{
        return DriverManager.getConnection(link, username, password);
    }
    
}
