
package car_management_system;




import static car_management_system.NewJFrame.add_panel;
import static car_management_system.NewJFrame.result_panel;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;


public class LeftMenuButton extends JButton implements ActionListener{
    
    String[] label_texts;
    String select_statement,insert_statement,update_statement,delete_statement;
    
    
   
    public LeftMenuButton(String string ,String[] label_texts, 
    String select_statement, String insert_statement, String update_statement, String delete_statement) {
        super(string);
        this.label_texts = label_texts;
        this.select_statement = select_statement;
        this.insert_statement = insert_statement;
        this.update_statement = update_statement;
        this.delete_statement = delete_statement;
        setBackground(Color.ORANGE);
        setFont(new Font("Serif", Font.BOLD, 30));
        addActionListener(this);
    }

    @Override
    public void actionPerformed(ActionEvent ae) {
        create_connection_prepare_result_panel("",false);
    }
    
    
    public void create_connection_prepare_result_panel(String column_name,boolean is_desc_sorting) {
        result_panel.removeAll();
        try(
            Connection connection=DBConection_MYSQL.get_MyDBConnection();
            CallableStatement statement=connection.prepareCall(select_statement);   
        ){
            statement.setString(1, column_name);
            statement.setBoolean(2, is_desc_sorting);
            ResultSet result = statement.executeQuery();
            
            create_add_button();
            create_array_from_results(result);

        } catch (SQLException ex) {
            Logger.getLogger(LeftMenuButton.class.getName()).log(Level.SEVERE, null, ex);
        }
        result_panel.revalidate();
        result_panel.repaint();
    }

    private void create_add_button() {
        add_panel.removeAll();
        add_panel.add(new AddNew_Button());
        add_panel.revalidate();
        add_panel.repaint();
    }

    private void create_array_from_results(ResultSet result) throws SQLException {
        int num_of_Columns = result.getMetaData().getColumnCount();
        int num_of_rows = 0;
        while (result.next())
        num_of_rows++;
        result.beforeFirst();
        
        Object table[][]=new Object[num_of_rows][num_of_Columns];
        
        num_of_rows=0;
        while (result.next()) {
            for (int j = 0; j < num_of_Columns; j++) 
                table[num_of_rows][j]=result.getObject(j+1);
            num_of_rows++;
        }
        if(table.length==0)return;
        show_db_results(table,result);
    }

    private void show_db_results(Object[][] table, ResultSet result) throws SQLException {
        result_panel.setSize(1400, 50*(table.length+1));
        result_panel.setLayout(new GridLayout(table.length+1,table[0].length+2));
        
            for(int j=0; j<table[0].length; j++)
            result_panel.add(new Table_Label_Title(result.getMetaData().getColumnName(j+1)));
            result_panel.add(new JLabel());//fake Label gia na einai sosta to gridlayout
            result_panel.add(new JLabel());//fake Label gia na einai sosta to gridlayout

                for(int i=0; i<table.length; i++){
                for(int j=0; j<table[0].length; j++)
                result_panel.add(new Table_Label(table[i][j].toString()));
                result_panel.add(new EditButton(table[i]));
                result_panel.add(new DeleteButton(table[i][0]));
                }
    }

    

    private class AddNew_Button extends JButton implements ActionListener{
        
        private AddNew_Button() {
            super(label_texts[label_texts.length-1]);
            setBackground(Color.cyan);
            setFont(new Font("Serif", Font.BOLD, 20));
            addActionListener(this);
        }

        @Override
        public void actionPerformed(ActionEvent ae) {
            new FormJFrame(insert_statement);
        }
    }
    
    private class EditButton extends JButton implements ActionListener{

        private final Object[] table_row;

        private EditButton(Object[] table_row) {
            super("Edit");
            this.table_row=table_row;
            setFont(new Font("Arial", Font.PLAIN, 25));
            setBackground(Color.yellow);
            addActionListener(this);
        }

        @Override
        public void actionPerformed(ActionEvent ae) {
            String update_statement_format=update_statement.replaceFirst("\\?",table_row[0].toString());
            FormJFrame formJFrame = new FormJFrame(update_statement_format);
            for(int i=0; i<formJFrame.textfields.length; i++)
            formJFrame.textfields[i].setText(table_row[i+1].toString());
        }
    }
    
    private class DeleteButton extends JButton implements ActionListener{

    private final Object id;
      
    private DeleteButton(Object id) {
        super("Delete");
        this.id=id;
        setFont(new Font("Arial", Font.PLAIN, 25));
        setBackground(Color.red);
        setForeground(Color.WHITE);
        addActionListener(this);
    }
    
    @Override
    public void actionPerformed(ActionEvent ae) {
        new DeleteFrame().setVisible(true);
    }
    
            private class DeleteFrame extends JFrame{

                    private DeleteFrame() {
                        setLocationRelativeTo(null);
                        setResizable(false);
                        setSize(300,200);
                        add(new QuestionLabel(), BorderLayout.PAGE_START);
                        add(new YesButton(), BorderLayout.LINE_START);
                        add(new NoButton(), BorderLayout.LINE_END);
                    }

                            private class QuestionLabel extends JLabel{
                                private QuestionLabel() {
                                    super("<html>Are you sure you <br> want to delete this?</html>");
                                    setFont(new Font("Arial", Font.PLAIN, 20));
                                    setHorizontalAlignment(SwingConstants.CENTER);
                                    setPreferredSize(new Dimension(300,100));
                                }  
                            }

                            private class YesButton extends JButton implements ActionListener{
                                private YesButton() {
                                    super("YES");
                                    setFont(new Font("Arial", Font.PLAIN, 25));
                                    setPreferredSize(new Dimension(150,100));
                                    addActionListener(this);
                                }
                                @Override
                                public void actionPerformed(ActionEvent ae) {               
                                     try(
                                     Connection connection=DBConection_MYSQL.get_MyDBConnection();
                                     CallableStatement statement=connection.prepareCall(delete_statement);
                                     ){
                                     statement.setObject(1,id);
                                     statement.executeUpdate();
                                    } catch (SQLException ex) {
                                        Logger.getLogger(DeleteFrame.class.getName()).log(Level.SEVERE, null, ex);
                                    }finally{
                                    DeleteFrame.this.dispose();
                                    LeftMenuButton.this.doClick();
                                    }
                                }
                            }

                            private class NoButton extends JButton implements ActionListener{
                                private NoButton() {
                                    super("NO");
                                    setFont(new Font("Arial", Font.PLAIN, 25));
                                    setPreferredSize(new Dimension(150,100));
                                    addActionListener(this);
                                }
                                @Override
                                public void actionPerformed(ActionEvent ae) {
                                    DeleteFrame.this.dispose();
                                }
                            } 
            }
    }
    
    
    private class Table_Label extends JLabel{
        private Table_Label(String string) {
            super(string);
            setFont(new Font("Arial", Font.PLAIN, 25));
            setHorizontalAlignment(SwingConstants.CENTER);
            setBorder(BorderFactory.createLineBorder(Color.black));
        }
    }
    
    
    private class Table_Label_Title extends Table_Label implements MouseListener{

        private final String title_text;

        private Table_Label_Title(String title_text) {
            super(title_text);
            this.title_text=title_text;
            setOpaque(true);
            setBackground(Color.GREEN);
            addMouseListener(this);   
        }
        
        public void mouseClicked(MouseEvent me) {   
            if(SwingUtilities.isLeftMouseButton(me))
            create_connection_prepare_result_panel(title_text,false);
            if(SwingUtilities.isRightMouseButton(me))
            create_connection_prepare_result_panel(title_text,true);
        }
        
        @Override public void mouseEntered(MouseEvent me) {}@Override public void mouseExited(MouseEvent me) {}
        @Override public void mousePressed(MouseEvent me) {}@Override public void mouseReleased(MouseEvent me) {}
    }
    
    
    private class FormJFrame extends JFrame{
    

    private JTextField[] textfields;
    private final String callstatement;

    private FormJFrame(String callstatement) {
        this.callstatement = callstatement;
        setResizable(false);
        setSize(label_texts.length*100,400);
        setLayout(new GridLayout(label_texts.length,2));
        set_the_components();
        setVisible(true);
    }

    private void set_the_components() {
        textfields=new JTextField[label_texts.length-1];
        for(int i=0; i<textfields.length; i++){
            JLabel newlabel=new JLabel(label_texts[i],SwingConstants.CENTER);
            newlabel.setFont(new Font("Arial", Font.PLAIN, 40));
            add(newlabel);
            add(textfields[i]=new JTextField());
            textfields[i].setFont(new Font("Arial", Font.PLAIN, 40));
        }
        add(new JLabel());//fake Label gia na einai sosta to gridlayout
        add(new SubmitButton());
    }
    
    
    private class SubmitButton extends JButton implements ActionListener{
        
        private SubmitButton() {
            super("SUBMIT");
            setFont(new Font("Arial", Font.PLAIN, 30));
            setBackground(Color.BLUE);
            setForeground(Color.WHITE);
            addActionListener(this);
        }

        @Override
        public void actionPerformed(ActionEvent ae) {
            if(a_textfield_is_empty())return;
            try(
                Connection connection=DBConection_MYSQL.get_MyDBConnection();
                CallableStatement statement=connection.prepareCall(callstatement);
            ){
                for(int i=0; i<textfields.length; i++)
                statement.setObject(i+1,textfields[i].getText());
                statement.executeUpdate();
            } catch (SQLException ex) {
                Logger.getLogger(FormJFrame.class.getName()).log(Level.SEVERE, null, ex);
            } finally{             
               FormJFrame.this.dispose();                   
               LeftMenuButton.this.doClick();
            } 
        }
        
        private boolean a_textfield_is_empty() {
            for(int i=0; i<textfields.length; i++)if(textfields[i].getText().isEmpty())return true;return false;    
        }

    }


}


}
    

