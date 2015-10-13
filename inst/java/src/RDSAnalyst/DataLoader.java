package RDSAnalyst;

import java.awt.FlowLayout;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.filechooser.FileFilter;

import org.rosuda.JGR.JGR;
import org.rosuda.JGR.RController;
import org.rosuda.JGR.editor.Editor;
import org.rosuda.JGR.toolkit.ExtensionFileFilter;
import org.rosuda.JGR.toolkit.FileSelector;
import org.rosuda.JGR.util.ErrorMsg;
import org.rosuda.REngine.REXP;
import org.rosuda.REngine.REXPLogical;
import org.rosuda.REngine.REXPMismatchException;
import org.rosuda.REngine.REngineException;
import org.rosuda.deducer.Deducer;
/**
 * Adapted from the JGR DataLoader
 * 
 * @author ianfellows
 *
 */
public class DataLoader extends JFrame implements PropertyChangeListener {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7945677424441713542L;
	private static String extensions[][] = new String[][] { {"rdsobj"}, {"rdsat"}, { "net" }, { "robj" }, { "csv" }, { "txt" }, { "sav" }, { "xpt" }, { "dbf" },
			{ "dta" }, { "syd", "sys" }, { "arff" }, { "rec" }, { "mtp" }, { "s3" }, { "xls", "xlsx" } };
	private static String extensionDescription[] = new String[] { "RDS Analyst (*.rdsobj)","RDSAT (*.rdsat)", "Pajek (*.net)", "R dput() (*.robj)", "Comma seperated (*.csv)",
			"Text file (*.txt)", "SPSS (*.sav)", "SAS export (*.xpt)", "DBase (*.dbf)", "Stata (*.dta)", "Systat (*.sys *.syd)", "ARFF (*.arff)",
			"Epiinfo (*.rec)", "Minitab (*.mtp)", "S data dump (*.s3)", "Excel (*.xls *.xlsx)" };
	private JTextField rDataNameField;
	private String rName;
	private FileSelector fileDialog;

	public static void run(){
		new Thread(new Runnable(){
			public void run() {
				new DataLoader();				
			}
			
		}).start();		
	}
	
	public DataLoader() {
		try {
			FileFilter extFilter;
			fileDialog = new FileSelector(this, "Load Data", FileSelector.LOAD, null, true);
			JFileChooser chooser = fileDialog.getJFileChooser();
			for (int i = 0; i < extensionDescription.length; i++) {
				extFilter = new ExtensionFileFilter(extensionDescription[i], extensions[i]);
				chooser.addChoosableFileFilter(extFilter);
			}
			chooser.setFileFilter(chooser.getAcceptAllFileFilter());
			JPanel namePanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
			namePanel.add(new JLabel("Set name: "));
			rDataNameField = new JTextField(20);
			namePanel.add(rDataNameField);
			fileDialog.addFooterPanel(namePanel);
			fileDialog.getJFileChooser().addPropertyChangeListener(this);
			fileDialog.setVisible(true);
			if (fileDialog.getFile() == null)
				return;
			rName = rDataNameField.getText();
			if (rName.length() == 0)
				rName = (fileDialog.getFile().indexOf(".") <= 0 ? JGR.MAINRCONSOLE.getUniqueName(fileDialog.getFile()) : JGR.MAINRCONSOLE
						.getUniqueName(fileDialog.getFile().substring(0, fileDialog.getFile().indexOf("."))));
			rName = RController.makeValidVariableName(rName);
			loadData(addSlashes(fileDialog.getFile()), fileDialog.getDirectory(), rName);	


		} catch (Exception er) {
			new ErrorMsg(er);
		}

	}

	public void loadData(String fileName, String directory, String var) {
		boolean convert = true;
		try{
			JGR.getREngine().parseAndEval("suppressWarnings(rm('"+var+"'))");
		}catch(Exception ex){}
		if (fileName.toLowerCase().endsWith(".robj"))
			loadDputFile(fileName, directory,var);
		else if (fileName.toLowerCase().endsWith(".net")){
			Deducer.execute(var + " <- read.paj('" + (directory ).replace('\\', '/')+ fileName + "')", true);
			convert=false;
		}
		else if (fileName.toLowerCase().endsWith(".txt") | fileName.toLowerCase().endsWith(".csv")){
			//begin RDSA edit
			try{
				BufferedReader reader = new BufferedReader(new FileReader(directory.replace('\\','/') + fileName));
				String line1 = null;
				line1 = reader.readLine();
				reader.close();
				if(line1.trim().equals("RDS") | line1.trim().equals("rds")){
					Deducer.execute(var + " <- read.rdsat('" + (directory ).replace('\\', '/')+ fileName + "')", true);
				}else	
					loadTxtFile(fileName, directory, var);
			}catch(Exception ex){
				ex.printStackTrace();
				loadTxtFile(fileName, directory, var);
			}
			convert=false;
			//end edit
		}else {
			try {
				RController.loadPackage("foreign");
				if (fileName.toLowerCase().endsWith(".sav"))
					Deducer.execute(var + " <- read.spss('" + (directory + fileName).replace('\\', '/') + "',to.data.frame=TRUE,trim.factor.names=TRUE)", true);
				else if (fileName.toLowerCase().endsWith(".xpt") | fileName.toLowerCase().endsWith(".xport"))
					Deducer.execute(var + " <- read.xport('" + (directory ).replace('\\', '/')+ fileName + "')", true);
				else if (fileName.toLowerCase().endsWith(".dta"))
					Deducer.execute(var + " <- read.dta('" + (directory ).replace('\\', '/')+ fileName + "')", true);
				else if (fileName.toLowerCase().endsWith(".arff"))
					Deducer.execute(var + " <- read.arff('" + (directory ).replace('\\', '/')+ fileName + "')", true);
				else if (fileName.toLowerCase().endsWith(".rec"))
					Deducer.execute(var + " <- read.epiinfo('" + (directory ).replace('\\', '/')+ fileName + "')", true);
				else if (fileName.toLowerCase().endsWith(".mtp"))
					Deducer.execute(var + " <- as.data.frame(read.mtp('" + (directory ).replace('\\', '/')+ fileName + "'))", true);
				else if (fileName.toLowerCase().endsWith(".s3"))
					Deducer.execute("data.restore('" + (directory ).replace('\\', '/')+ fileName + "',print=TRUE)", true);
				else if (fileName.toLowerCase().endsWith(".syd") || fileName.toLowerCase().endsWith(".sys"))
					Deducer.execute(var + " <- read.systat('" + (directory ).replace('\\', '/')+ fileName + "')", true);
				else if (fileName.toLowerCase().endsWith(".dbf"))
					Deducer.execute(var + " <- read.dbf('" + (directory ).replace('\\', '/')+ fileName + "')", true);
				else if (fileName.toLowerCase().endsWith(".xls")||fileName.toLowerCase().endsWith(".xlsx")){
					RController.loadPackage("XLConnect");
					Deducer.execute(var + " <- readWorksheet(loadWorkbook('" + (directory ).replace('\\', '/')+ fileName + "'),sheet=1)", true);
				}else if (fileName.toLowerCase().endsWith(".rdsobj")){
					Deducer.execute(var + " <- read.rdsobj('" + (directory ).replace('\\', '/')+ fileName + "')", true);
					convert=false;
				}else if (fileName.toLowerCase().endsWith(".net")){
					Deducer.execute(var + " <- read.paj('" + (directory ).replace('\\', '/')+ fileName + "')", true);
					convert=false;
				}else if (fileName.toLowerCase().endsWith(".rdsat")){
					Deducer.execute(var + " <- read.rdsat('" + (directory ).replace('\\', '/')+ fileName + "')", true);
					convert=false;
				}else {
					int opt = JOptionPane.showConfirmDialog(this, "Unknown File Type.\nWould you like to try to open it as a text data file?");
					if (opt == JOptionPane.OK_OPTION){
						loadTxtFile(fileName, directory, var);
						convert=false;
					}
				}
			} catch (Exception e) {
				new ErrorMsg(e);
				convert=false;
			}
		}
		Deducer.execute("if(!('rds.data.frame' %in% class(" + var + "))){" + var + " <- as.data.frame(sapply(" + var + ",save_str_trim,simplify=FALSE))}", true);
		if(convert)
			convertData(var);
	}
	
	public static void convertData(String name){
		final String theName = name;
		(new Thread(new Runnable(){

			public void run() {
				boolean cont = true;
				int counter=0;
				while(cont){
					
					try{
						Thread.sleep(300);
						//System.out.println("counter:"+counter);
						REXP ext = JGR.getREngine().parseAndEval("exists('" + theName +"')");
						boolean exist = ((REXPLogical) ext).isTRUE()[0];
						if(exist){
							cont=false;
							JGR.getREngine().parseAndEval("DeducerRDSAnalyst:::.makePostLoadDialog('" + theName +"')$run()");
						}
						if(counter>200)
							cont=false;
						counter++;
					}catch(Exception ex){}
					
				}
			}
			
		})).start();
	}

	public void loadRdaFile(String fileName, String directory) {
		String cmd = "print(load(\"" + (directory.replace('\\', '/') + fileName) + "\"))";
		try {
			JGR.eval("cat('The following data objects have been loaded:\\\n')");
		} catch (REngineException e) {
			new ErrorMsg(e);
		} catch (REXPMismatchException e) {
			new ErrorMsg(e);
		}
		Deducer.execute(cmd, true);
	}

	public void loadDputFile(String fileName, String directory,String var) {
		Deducer.execute(var + " <- dget('" + (directory + fileName).replace('\\', '/') + "')", true);
	}

	public void loadTxtFile(String fileName, String directory, String rName) {
		TxtTableLoader.run(directory.replace('\\','/') + fileName, rName);
	}

	public String getDataName() {
		return rName;
	}

	/**
	 * propertyChange: handle propertyChange, used for setting the name where
	 * the set should be assigned to.
	 */
	public void propertyChange(PropertyChangeEvent e) {
		File file = fileDialog.getSelectedFile();
		if (e.getPropertyName() == "SelectedFileChangedProperty") {
			if (file != null && !file.isDirectory()
					&& !(file.getName().toLowerCase().endsWith(".rdata") || file.getName().toLowerCase().endsWith(".rda"))) {
				String name = file.getName().replaceAll("\\..*", "");
				name = JGR.MAINRCONSOLE.getUniqueName(name);
				rDataNameField.setText(name);
			} else
				rDataNameField.setText("");
		}
	}
	private static String addSlashes(String str){
		if(str==null) return "";

		StringBuffer s = new StringBuffer(str);
		for(int i = 0; i < s.length(); i++){
			if(s.charAt (i) == '\"')
				s.insert(i++, '\\');
			else if(s.charAt (i) == '\'')
				s.insert(i++, '\\');
		}
		
		return s.toString();
	}
}
