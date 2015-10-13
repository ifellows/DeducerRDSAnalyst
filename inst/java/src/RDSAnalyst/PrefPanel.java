package RDSAnalyst;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JCheckBox;

import javax.swing.WindowConstants;
import javax.swing.JFrame;

import org.rosuda.JGR.toolkit.PrefDialog;
import org.rosuda.deducer.toolkit.DeducerPrefs;



public class PrefPanel extends PrefDialog.PJPanel implements ActionListener {
	private JCheckBox pro;
	
	public static boolean defaultProVersion = false;
	
	public PrefPanel() {
		super();
		initGUI();
	}
	
	private void initGUI() {
		try {
			this.setPreferredSize(new java.awt.Dimension(453, 335));
			this.setLayout(null);
			{
				pro = new JCheckBox();
				this.add(pro);
				pro.setText("Professional Version (Restart required)");
				pro.setBounds(147, 142, 280, 19);
				pro.setSelected(true);
			}
			this.setName("RDS Analyst");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void saveAll() {
		DeducerPrefs.set("RDSANALYST_PRO_VERSION",pro.isSelected() ? "true" : "false");
	}
	
	public void resetToFactory() {
		pro.setSelected(defaultProVersion);
	}
	
	public void reset() {
		String p = DeducerPrefs.get("RDSANALYST_PRO_VERSION");
		if(p==null)
			pro.setSelected(defaultProVersion);
		else
			pro.setSelected(p.toLowerCase().equals("true"));
	}

	public void actionPerformed(ActionEvent e) {
		String cmd = e.getActionCommand();
		if(cmd == "Save All"){
			saveAll();
		}else if(cmd == "Cancel"){
			reset();
		}else if(cmd == "Reset All"){
			resetToFactory();
		}
		
	}


}
