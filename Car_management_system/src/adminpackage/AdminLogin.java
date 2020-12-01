package adminpackage;

import car_management_system.DBConection_MYSQL;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.WindowConstants;


class AdminLogin extends JFrame{
    
    private JTextField username_TextField;
    private JPasswordField password_TextField;
    private LoginButton loginbutton;
    public static void main(String[] args) {
       new AdminLogin().setVisible(true);
    }

    AdminLogin(){
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setResizable(false);
        setSize(250,120);
        setLocationRelativeTo(null);
        addComponents();
    }

    private void addComponents() {
        JPanel formpanel = new JPanel(new GridLayout(2,2));
        formpanel.add(new JLabel("Username",SwingConstants.CENTER));formpanel.add(username_TextField=new JTextField());
        formpanel.add(new JLabel("Password",SwingConstants.CENTER));formpanel.add(password_TextField=new JPasswordField());
        add(formpanel, BorderLayout.CENTER);
        add(loginbutton=new LoginButton(), BorderLayout.SOUTH);
        getRootPane().setDefaultButton(loginbutton);
    }

    private class LoginButton extends JButton implements ActionListener {
        
        private LoginButton() {
            super("Login");
            setFont(new Font("Arial", Font.PLAIN, 20));
            setHorizontalAlignment(SwingConstants.CENTER);
            setBackground(Color.BLUE);
            setForeground(Color.WHITE);
            addActionListener(this);
        }

        @Override
        public void actionPerformed(ActionEvent ae) {
            try(
             Connection connection=DBConection_MYSQL.get_MyDBConnection();
             CallableStatement statement=connection.prepareCall("{call select_user(?,?)}");
            ){
                statement.setString(1, username_TextField.getText());
                statement.setString(2, String.valueOf(password_TextField.getPassword()));
                ResultSet result = statement.executeQuery();
                if (result.isBeforeFirst()) {               
                       AdminLogin.this.dispose();
                       new AdminFrame().setVisible(true);
                }
            }catch (SQLException ex) {
                Logger.getLogger(AdminLogin.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
  
}
}
