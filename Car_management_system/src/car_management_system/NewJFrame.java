
package car_management_system;





import java.awt.Color;
import java.awt.GridLayout;
import javax.swing.JPanel;



public class NewJFrame extends javax.swing.JFrame {
   
    public static JPanel left_menu_panel,result_panel,add_panel;  

    public NewJFrame() {
        initComponents();
        setSize(1800, 1000);
        setResizable(false);
        createpanels();
    }
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 400, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    public static void main(String args[]) {
        
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new NewJFrame().setVisible(true);
            }
        });
    }

    private void createpanels() {
            
            left_menu_panel=new JPanel();
            left_menu_panel.setSize (250,200);
            left_menu_panel.setLocation(50, 50);
            left_menu_panel.setLayout(new GridLayout(2,1));
            add(left_menu_panel);
            create_left_menu_components();
            
            
            result_panel=new JPanel();
            result_panel.setLocation(350, 25);
            result_panel.setBackground(Color.WHITE);
            add(result_panel);
            
            add_panel= new JPanel();
            add_panel.setSize (150,100);
            add_panel.setLocation(100, 420);
            add_panel.setLayout(new GridLayout(1,1));
            add(add_panel);
    }

    private void create_left_menu_components() {
                left_menu_panel.add(new LeftMenuButton( "CAR LIST",
                                                        new String[] {"Brand","Model","Year","Engine","Color","Price","ADD CAR"},
                                                        "{call select_vehicles(?,?)}",
                                                        "{call insert_new_car(?,?,?,?,?,?)}",
                                                        "{call update_car(?,?,?,?,?,?,?)}",
                                                        "{call delete_car(?)}"));
                left_menu_panel.add(new LeftMenuButton( "SALES LIST",
                                                        new String[] {"Name","Surname","Email","Phone","City","Car ID","ADD SALE"},
                                                        "{call select_sales(?,?)}",
                                                        "{call insert_new_sale(?,?,?,?,?,?)}",
                                                        "{call update_sale(?,?,?,?,?,?,?)}",
                                                        "{call delete_sale(?)}"));
    }


   
    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables
}
