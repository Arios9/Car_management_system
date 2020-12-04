
package car_management_system;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBConection_MYSQL {
    
    private static final String link="";
    private static final String username="";
    private static final String password="";
    
    public static Connection get_MyDBConnection() throws SQLException{
        return DriverManager.getConnection(link, username, password);
    }
    
}
