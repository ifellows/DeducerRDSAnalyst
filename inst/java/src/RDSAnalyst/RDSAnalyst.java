package RDSAnalyst;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Image;
import java.awt.Insets;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.URL;
import java.util.ArrayList;

import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;

import org.rosuda.JGR.JGR;
import org.rosuda.JGR.robjects.RObject;
import org.rosuda.JGR.toolkit.FileSelector;
import org.rosuda.JGR.toolkit.PrefDialog;
import org.rosuda.REngine.REXPReference;
import org.rosuda.deducer.Deducer;
import org.rosuda.deducer.data.DataFrameSelector;
import org.rosuda.deducer.data.DataViewerController;
import org.rosuda.deducer.toolkit.DeducerPrefs;
import org.rosuda.deducer.toolkit.HelpButton;
import org.rosuda.deducer.toolkit.IconButton;
import org.rosuda.deducer.toolkit.SaveData;
import org.rosuda.deducer.widgets.ObjectChooserWidget;
import org.rosuda.deducer.widgets.RDialog;
import org.rosuda.deducer.widgets.SimpleRDialog;
import org.rosuda.deducer.data.DataViewer;
import org.rosuda.util.Platform;

public class RDSAnalyst {

	public static PrefPanel prefPanel;
	
	private static boolean started = false;
	
	public static void startUp(){
		new Thread(new Runnable(){

			public void run() {
				startUpImpl();
			}
			
		}).start();
	}
	
	private static void startUpImpl(){
		try{
			if(!started){
				if(!isPro()){
					new SplashWindow();
				}
				prefPanel = new PrefPanel();
				PrefDialog.addPanel(prefPanel, prefPanel);
				//System.out.println(isPro());
				DataViewerController.init();
				ArrayList win = DataViewerController.getViewerWindows();
				for(int i=0;i<win.size();i++)
					((DataViewer) win.get(i)).dispose();
				DataViewerController.setOpenDataVisible(false);
				DataViewerController.setSaveDataVisible(false);
				DataViewerController.setDefaultPanel(getDefaultViewerPanel());
				
				if(DeducerPrefs.VIEWERATSTARTUP || win.size()>0){
					DataViewer dv = new DataViewer();
					dv.setLocationRelativeTo(null);
					dv.setVisible(true);
				}

				DataViewerController.addDataType("rds.data.frame", "rds");
				DataViewerController.addTabFactory("rds.data.frame","Data View", new RDSDataViewFactory());
				DataViewerController.addTabFactory("rds.data.frame","Variable View", new RDSVariableViewFactory());
				DataViewerController.addTabFactory("rds.data.frame","RDS", new RDSMetDataViewFactory());
				if(!isPro()){
					try{
						URL url = new RDSAnalyst().getClass().getResource("/icons/RDSAnalyst.png");
						Toolkit kit = Toolkit.getDefaultToolkit();
						Image img = kit.createImage(url);
						JGR.MAINRCONSOLE.setIconImage(img);
					}catch(Exception e){}
				}
				started=true;
			}
		}catch(Exception e){
				System.out.println("Error starting up RDSAnalyst");
				e.printStackTrace();
			}
	}
	
	public static boolean isPro(){
		DeducerPrefs.initialize();
		String p = DeducerPrefs.get("RDSANALYST_PRO_VERSION");
		if(p==null)
			return prefPanel.defaultProVersion;
		else
			return p.toLowerCase().equals("true") ? true : false;
	}

	
	
	public static JPanel getDefaultViewerPanel(){
		JPanel panel = new JPanel();
		GridBagLayout panelLayout = new GridBagLayout();
		panelLayout.rowWeights = new double[] {0.1, 0.1, 0.25, 0.1, 0.1};
		panel.setLayout(panelLayout);
		ActionListener lis = new ActionListener(){
			public void actionPerformed(ActionEvent e) {
				String cmd = e.getActionCommand();
				if(cmd=="Open Data"){	
					new DataLoader();			
				}else if(cmd=="New Data"){
					String inputValue = JOptionPane.showInputDialog("Data Name: ");
					if(inputValue!=null)
						Deducer.eval(inputValue.trim()+"<-data.frame(Var1=NA)");
				}else if(cmd=="tutorial"){
					HelpButton.showInBrowser("http://neolab.stat.ucla.edu/cranstats/RDSAnalyst_tutorial.mov");
				}else if(cmd=="wiki"){
					HelpButton.showInBrowser("http://www.deducer.org/pmwiki/pmwiki.php?n=Main.RDSAnalyst");
				}
			}
		};
		JButton newButton = new IconButton("/icons/newdata_128.png","New Data Frame",lis,"New Data");
		newButton.setPreferredSize(new java.awt.Dimension(128,128));
		panel.add(newButton, new GridBagConstraints(0, 0, 1,1,  0.0, 0.0, 
				GridBagConstraints.CENTER, GridBagConstraints.NONE, new Insets(0, 0, 0, 0), 0, 0));
		
		IconButton openButton = new IconButton("/icons/opendata_128.png","Open Data Frame",lis,"Open Data");
		openButton.setPreferredSize(new java.awt.Dimension(128,128));
		panel.add(openButton, new GridBagConstraints(0, 1, 1,1,  0.0, 0.0,
				GridBagConstraints.CENTER, GridBagConstraints.NONE, new Insets(0, 0, 0, 0), 0, 0));
		
		IconButton vidButton = new IconButton("/icons/video_128.png","Online Tutorial Video",lis,"tutorial");
		vidButton.setPreferredSize(new java.awt.Dimension(128,128));
		panel.add(vidButton, new GridBagConstraints(0, 2, 1,1,  0.0, 0.0,
				GridBagConstraints.CENTER, GridBagConstraints.NONE, new Insets(0, 0, 0, 0), 0, 0));
		
		IconButton manButton = new IconButton("/icons/info_128.png","Online Manual",lis,"wiki");
		manButton.setPreferredSize(new java.awt.Dimension(128,128));
		panel.add(manButton, new GridBagConstraints(0, 3, 1,1,  0.0, 0.0,
				GridBagConstraints.CENTER, GridBagConstraints.NONE, new Insets(0, 0, 0, 0), 0, 0));
		return panel;
	}
	
	
	public static void runSaveFlatDialog(){
		SwingUtilities.invokeLater(new Runnable(){
			public void run() {
				RObject data = (new DataFrameSelector(JGR.MAINRCONSOLE)).getSelection();
				if(data!=null){
					SaveData inst = new SaveData(data.getName());
				}
			}
			
		});
	}
	
	public static void runSave(String format){
		final String form = format;
		SwingUtilities.invokeLater(new Runnable(){
			public void run() {
				RDialog dialog = new RDialog();
				dialog.setSize(370,175);
				final String title;
				if(form.equals("netdraw")){
					dialog.setTitle(title="Export to NetDraw");
				}else if(form.equals("graphviz")){
					dialog.setTitle(title="Export to GraphViz");
				}else if(form.equals("graphviz")){
					dialog.setTitle(title="Export to Gephi");
				}else{
					dialog.setTitle(title="Save RDS Data Set");			
				}
				dialog.addHelpButton("pmwiki.php?n=Main.RDSAnalystExportRDSData");	
				
				ObjectChooserWidget obj = new ObjectChooserWidget("RDS Data",dialog);
				obj.setClassFilter("rds.data.frame");
				dialog.add(obj, 10, 750, 600, 250,
						"ABS","REL",
						"REL","REL");
				final ObjectChooserWidget ob = obj;
				final RDialog dia = dialog;
				dialog.setOkayCancel(false, false, new ActionListener(){
				
					public void actionPerformed(ActionEvent e) {
						String cmd = e.getActionCommand();
						if(cmd.equals("OK")){
							dia.setVisible(false);
							FileSelector fileDialog ;
							fileDialog = new FileSelector(null, title, 1, null);
							fileDialog.setVisible(true);
							String file = fileDialog.getFile();
							if(file==null)
								return;
							String directory = fileDialog.getDirectory();
							
							if(Platform.isWin)
								directory = directory.replaceAll("\\\\", "/");
							String fileName = directory + file;
							if(form.equals("netdraw")){
								Deducer.execute("write.netdraw(" + 
										ob.getModel() + ", '" + fileName + "')");
							}else if(form.equals("graphviz")){
								if(!fileName.endsWith(".gv"))
									fileName = fileName + ".gv";
								Deducer.execute("write.graphviz(" + 
										ob.getModel() + ", '" + fileName + "')");								
							}else if(form.equals("gephi")){
								if(!fileName.endsWith(".gexf"))
									fileName = fileName + ".gexf";
								Deducer.execute("write.gephi(" + 
										ob.getModel() + ", '" + fileName + "')");								
							}else{
								if(!fileName.endsWith(".rdsobj"))
									fileName = fileName + ".rdsobj";
								Deducer.execute("write.rdsobj(" + 
										ob.getModel() + ", '" + fileName + "')");									
							}
							dia.completed();
						}
						
					}
					
				});
				dialog.setLocationRelativeTo(null);
				dialog.run();
			}
			
		});
	}
	//J("RDSAnalyst.RDSAnalyst")$runSave()
	
}
