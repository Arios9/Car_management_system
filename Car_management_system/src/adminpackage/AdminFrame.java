
package adminpackage;

import car_management_system.DBConection_MYSQL;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.SwingConstants;
import javax.swing.WindowConstants;


 public class AdminFrame extends JFrame{
     
    private JPanel leftpanel,rightpanel,actions_panel;
    private CodeArea codearea;

    AdminFrame() {
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        setSize(1800, 1000);
        setResizable(false);
        setLayout(new GridLayout(1,2));
        prepare_panels();
    }

    private void prepare_panels() {
        setleftpanel();
        setrigthpanel();
        show_action_history();
    }

    private void setleftpanel() {
        leftpanel = new JPanel();
        leftpanel.add(new TopLabel("SQLi"),BorderLayout.NORTH);
        codearea=new CodeArea();
        leftpanel.add(codearea, BorderLayout.CENTER);
        leftpanel.add(new ExecuteButton(), BorderLayout.SOUTH);
        add(leftpanel);
    }

    private void setrigthpanel() {
        rightpanel =  new JPanel();
        rightpanel.add(new TopLabel("ACTION HISTORY"),BorderLayout.NORTH);
        actions_panel=new JPanel();
        rightpanel.add(new ReloadButton(),BorderLayout.CENTER);
        rightpanel.add(actions_panel, BorderLayout.SOUTH);
        add(rightpanel);
    }
    
     
    private void show_action_history()  {
        try(
            Connection connection=DBConection_MYSQL.get_MyDBConnection();
            CallableStatement statement=connection.prepareCall("{call select_action_history()}");   
        ){
            ResultSet result = statement.executeQuery();
            create_from_results(result);
        }  catch (SQLException ex) {
            Logger.getLogger(AdminFrame.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private void create_from_results(ResultSet result) throws SQLException {
        
        int num_of_Columns = result.getMetaData().getColumnCount();
        int num_of_rows = 0;
        while (result.next())
        num_of_rows++;
        result.beforeFirst();
        actions_panel.setSize(900, 50*(num_of_rows+1));
        actions_panel.setLayout(new GridLayout(num_of_rows+1,num_of_Columns));
        
        for(int j=0; j<num_of_Columns; j++)
        actions_panel.add (new Table_Label_Title(result.getMetaData().getColumnName(j+1)));
        while (result.next())
        for(int j=0; j<num_of_Columns; j++)
        actions_panel.add(new Table_Label(result.getObject(j+1).toString()));
    }


    private class TopLabel extends JLabel {
        private TopLabel(String string) {
            super(string);
            setFont(new Font("Arial", Font.PLAIN, 40));
            setHorizontalAlignment(SwingConstants.CENTER);
            setPreferredSize(new Dimension(900,100));
        }
    }
    
    private class CodeArea extends JTextArea {
        private CodeArea() {
            setFont(new Font("Arial", Font.PLAIN, 40));
            setPreferredSize(new Dimension(900,800));
        }
    }
    
    private  class ExecuteButton extends JButton implements ActionListener{
        
        private ExecuteButton() {
            super("Execute");
            setFont(new Font("Arial", Font.PLAIN, 30));
            setPreferredSize(new Dimension(200,50));
            setBackground(Color.LIGHT_GRAY);
            addActionListener(this);
        }

        @Override
        public void actionPerformed(ActionEvent ae) {
                try (Connection connection=DBConection_MYSQL.get_MyDBConnection();
                     Statement statement = connection.createStatement();
                ) {
                    statement.execute(codearea.getText());
                    codearea.setText(null);
                } catch (SQLException ex) {
                    Logger.getLogger(AdminFrame.class.getName()).log(Level.SEVERE, null, ex);
                }
        }
    }
   
    
    private class Table_Label extends JLabel{
        private Table_Label(String string) {
            super(string);
            setFont(new Font("Arial", Font.PLAIN, 20));
            setHorizontalAlignment(SwingConstants.CENTER);
            setBorder(BorderFactory.createLineBorder(Color.black));
        }
    }
    
    private class Table_Label_Title extends Table_Label{
        private Table_Label_Title(String title_text) {
            super(title_text);
            setOpaque(true);
            setBackground(Color.GREEN);
        }   
    }
    
    private class ReloadButton extends JButton implements ActionListener{
        private ReloadButton() {
            super("Reload");
            setFont(new Font("Arial", Font.PLAIN, 30));
            setPreferredSize(new Dimension(200,50));
            setBackground(Color.LIGHT_GRAY);
            addActionListener(this);
        }

        @Override
        public void actionPerformed(ActionEvent ae) {
            actions_panel.removeAll();
            show_action_history(); 
            actions_panel.revalidate();
            actions_panel.repaint();
        }
    }
    
    
    
}
