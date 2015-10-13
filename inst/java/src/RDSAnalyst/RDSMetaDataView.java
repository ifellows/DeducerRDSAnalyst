package RDSAnalyst;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JMenuBar;
import javax.swing.JPanel;
import javax.swing.DefaultListModel;
import javax.swing.border.BevelBorder;

import org.rosuda.JGR.layout.AnchorConstraint;
import org.rosuda.JGR.layout.AnchorLayout;
import org.rosuda.REngine.REXP;
import org.rosuda.REngine.REXPLogical;
import org.rosuda.deducer.data.DataViewerTab;
import org.rosuda.deducer.toolkit.SingletonAddRemoveButton;
import org.rosuda.deducer.toolkit.SingletonDJList;
import org.rosuda.deducer.widgets.ListWidget;
import org.rosuda.deducer.widgets.TextAreaWidget;
import org.rosuda.deducer.widgets.TextFieldWidget;
import org.rosuda.deducer.Deducer;

public class RDSMetaDataView extends DataViewerTab{

	protected String dataName;
	protected String guiEnv = Deducer.guiEnv;
	protected String tmpData = null;
	
	protected JButton notRDSButton;
	
	protected JPanel panel;
	protected boolean panelShowing=true;
	protected ListWidget varList;
	private JPanel idPanel;
	private SingletonDJList id;
	private SingletonAddRemoveButton idButton;
	private JPanel recruiterPanel;
	private SingletonDJList recruiter;
	private SingletonAddRemoveButton recruiterButton;
	private JPanel networkPanel;
	private SingletonDJList network;
	private SingletonAddRemoveButton networkButton;
	private JPanel intPanel;
	private JLabel couponNumLabel;
	private TextFieldWidget couponNum;
	private JLabel popLabel;
	private TextFieldWidget low;
	private TextFieldWidget mid;
	private TextFieldWidget high;
	private TextAreaWidget notes;
	public RDSMetaDataView(String dataName){
		super();
		initGui();
		setData(dataName);
	}
	
	protected void initGui(){
		try{
			panel = new JPanel();
			AnchorLayout thisLayout = new AnchorLayout();
			panel.setLayout(thisLayout);
			panel.setBorder(new BevelBorder(BevelBorder.LOWERED));
			varList = new ListWidget();
			panel.add(varList, new AnchorConstraint(20, 450, 540, 50,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_REL, AnchorConstraint.ANCHOR_REL));
			
			idPanel = new JPanel();
			idPanel.setBorder(BorderFactory.createTitledBorder("SubjectID"));
			idPanel.setLayout(new BorderLayout());
			idPanel.setPreferredSize(new Dimension(100,50));
			panel.add(idPanel, new AnchorConstraint(20, 950, 120, 600,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));
			id = new SingletonDJList();
			id.setBorder(BorderFactory.createBevelBorder(1));
			idPanel.add(id);
			
			idButton = new SingletonAddRemoveButton(new String[] {"add","remove"},
					new String[] {"add","remove"},id,varList.getList());
			idButton.setPreferredSize(new Dimension(36,36));
			panel.add(idButton, new AnchorConstraint(30, 950, 120, 500,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_NONE,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));
			
			recruiterPanel = new JPanel();
			recruiterPanel.setBorder(BorderFactory.createTitledBorder("Recruiter ID"));
			recruiterPanel.setLayout(new BorderLayout());
			recruiterPanel.setPreferredSize(new Dimension(50,50));
			panel.add(recruiterPanel, new AnchorConstraint(120, 950, 220, 600,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));
			
			recruiter = new SingletonDJList();
			recruiter.setBorder(BorderFactory.createBevelBorder(1));
			recruiterPanel.add(recruiter);
			
			recruiterButton = new SingletonAddRemoveButton(new String[] {"add","remove"},
					new String[] {"add","remove"},recruiter,varList.getList());
			recruiterButton.setPreferredSize(new Dimension(36,36));
			panel.add(recruiterButton, new AnchorConstraint(130, 950, 230, 500,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_NONE,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));
			
			networkPanel = new JPanel();
			networkPanel.setBorder(BorderFactory.createTitledBorder("Network Size"));
			networkPanel.setLayout(new BorderLayout());
			networkPanel.setPreferredSize(new Dimension(50,50));
			panel.add(networkPanel, new AnchorConstraint(220, 950, 320, 600,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));
			
			network = new SingletonDJList();
			network.setBorder(BorderFactory.createBevelBorder(1));
			networkPanel.add(network);
			
			networkButton = new SingletonAddRemoveButton(new String[] {"add","remove"},
					new String[] {"add","remove"},network ,varList.getList());
			networkButton.setPreferredSize(new Dimension(36,36));
			panel.add(networkButton, new AnchorConstraint(230, 950, 330, 500,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_NONE,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));
			
			intPanel = new JPanel();
			intPanel.setBorder(BorderFactory.createTitledBorder("Optional"));
			intPanel.setLayout(new AnchorLayout());
			panel.add(intPanel, new AnchorConstraint(550, 950, 990, 50,
					AnchorConstraint.ANCHOR_REL, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_REL, AnchorConstraint.ANCHOR_REL));
			intPanel.setSize(405,134);
			
			couponNumLabel = new JLabel("Max # of Coupons:");
			couponNumLabel.setHorizontalAlignment(4);
			intPanel.add(couponNumLabel, new AnchorConstraint(20, 400, 150, 10,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));
			
			couponNum = new TextFieldWidget();
			couponNum.setTitle("couponNum");
			couponNum.setInteger(true);
			couponNum.setLowerBound(1.0);
			intPanel.add(couponNum, new AnchorConstraint(18, 560, 230, 410,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));			
		
			int popTop = 50;
			popLabel = new JLabel("Population Size Esimate:");
			popLabel.setHorizontalAlignment(4);
			intPanel.add(popLabel, new AnchorConstraint(popTop+25, 400, 150, 10,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));	
			
			low = new TextFieldWidget("Low");
			low.setInteger(true);
			low.setLowerBound(1.0);
			intPanel.add(low, new AnchorConstraint(popTop, 560, 200, 410,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));	
			
			mid = new TextFieldWidget("Mid");
			mid.setInteger(true);
			mid.setLowerBound(1.0);
			intPanel.add(mid, new AnchorConstraint(popTop, 720, 200, 570,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));
			
			high = new TextFieldWidget("High");
			high.setInteger(true);
			high.setLowerBound(1.0);
			intPanel.add(high, new AnchorConstraint(popTop, 880, 200, 730,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_NONE, AnchorConstraint.ANCHOR_REL));
			
			notes = new TextAreaWidget("Notes");
			intPanel.add(notes, new AnchorConstraint(popTop + 50, 990, 990, 10,
					AnchorConstraint.ANCHOR_ABS, AnchorConstraint.ANCHOR_REL,
					AnchorConstraint.ANCHOR_REL, AnchorConstraint.ANCHOR_REL));
			
			
			panel.setPreferredSize(new Dimension(450,600));
			panel.setMinimumSize(new Dimension(450,600));
			panel.setMaximumSize(new Dimension(450,600));
			panel.setAlignmentX(CENTER_ALIGNMENT);
			
			notRDSButton = new JButton("Convert to RDS");
			notRDSButton.setAlignmentX(CENTER_ALIGNMENT);
			notRDSButton.addActionListener(new ActionListener(){

				public void actionPerformed(ActionEvent arg0) {
					Deducer.eval(".makePostLoadDialog('"+dataName+"')$run()");
				}
				
			});
			
			this.setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
			
			
			this.add(Box.createVerticalGlue());
			this.add(panel);
			panelShowing=true;
			this.add(Box.createVerticalGlue());
		}catch(Exception e){e.printStackTrace();}
	}
	
	public void setData(String data) {
		dataName = data;
		tmpData = data + Math.random();
		Deducer.eval(guiEnv+"$"+tmpData + "<- NULL");
		refresh();
	}
	

	public void refresh() {

		try{
			REXP exists = Deducer.eval("exists('"+dataName+"')");
			if(exists==null || ((REXPLogical)exists).isFALSE()[0]){
				return;
			}
			
			REXP isRDS = Deducer.eval("is.rds.data.frame("+dataName+")");
			if(isRDS==null || ((REXPLogical)isRDS).isFALSE()[0]){
				if(panelShowing==true){
					this.removeAll();
					this.add(Box.createVerticalGlue());
					this.add(notRDSButton);
					panelShowing=false;
					this.add(Box.createVerticalGlue());
					this.repaint();
				}
				return;
			}else{
				if(panelShowing==false){
					this.removeAll();
					this.add(Box.createVerticalGlue());
					this.add(panel);
					panelShowing=true;
					this.add(Box.createVerticalGlue());		
					this.repaint();
				}
			}
			
			
			//Deducer.execute("identical(attributes("+dataName+"),"+guiEnv+"$"+tmpData+")");
			REXP rexp = Deducer.eval("identical(attributes("+dataName+"),"+guiEnv+"$"+tmpData+")");
			if(rexp!=null && ((REXPLogical)rexp).isFALSE()[0]){
				
				String[] names = Deducer.eval("names("+dataName + ")").asStrings();
				varList.removeAllItems();
				varList.addItems(names);
				
				String res = Deducer.eval("attr("+dataName+",'id')").asString();
				((DefaultListModel) id.getModel()).removeAllElements();
				((DefaultListModel) id.getModel()).addElement(res);
				varList.removeItem(res);
				
				res = Deducer.eval("attr("+dataName+",'recruiter.id')").asString();
				((DefaultListModel) recruiter.getModel()).removeAllElements();
				((DefaultListModel) recruiter.getModel()).addElement(res);
				varList.removeItem(res);
				
				res = Deducer.eval("attr("+dataName+",'network.size')").asString();
				((DefaultListModel) network.getModel()).removeAllElements();
				((DefaultListModel) network.getModel()).addElement(res);
				varList.removeItem(res);
				
				res = Deducer.eval("as.character(if(is.null(attr("+dataName+
						",'max.coupons'))) '' else attr("+dataName+",'max.coupons'))").asString();
				couponNum.setModel(res);
				
				res = Deducer.eval("as.character(if(is.null(attr("+dataName+
						",'population.size.low'))) '' else attr("+dataName+",'population.size.low'))").asString();
				low.setModel(res);
				
				res = Deducer.eval("as.character(if(is.null(attr("+dataName+
						",'population.size.mid'))) '' else attr("+dataName+",'population.size.mid'))").asString();
				mid.setModel(res);
				
				res = Deducer.eval("as.character(if(is.null(attr("+dataName+
						",'population.size.high'))) '' else attr("+dataName+",'population.size.high'))").asString();
				high.setModel(res);
				
				res = Deducer.eval("as.character(if(is.null(attr("+dataName+
						",'notes'))) '' else attr("+dataName+",'notes'))").asString();
				notes.setText(res);
				
				Deducer.eval(guiEnv+"$"+tmpData + " <- attributes(" +dataName+")");				
			}else{
				if(recruiter.getModel().getSize()==0 ||
						network.getModel().getSize()==0 ||
						id.getModel().getSize()==0 )
					return;
				
				String l =  low.getModel().toString();
				if(l==null || l.equals(""))
					l = "NA";
				String m = mid.getModel().toString() ;
				if(m==null || m.equals(""))
					m = "NA";
				String h = high.getModel().toString();
				if(h==null || h.equals(""))
					h = "NA";
				String cmd = dataName + " <- as.rds.data.frame(" +dataName + 
					",id='"+id.getModel().getElementAt(0) +
					"', recruiter.id='"+ recruiter.getModel().getElementAt(0) +
					"',network.size='"+ network.getModel().getElementAt(0) +
					"',population.size=c("+l+","+m+","+h+")" +
					",max.coupons="+ couponNum.getModel() +
					",notes = \""+Deducer.addSlashes(notes.getText())+"\")";
				Deducer.eval(cmd);
				Deducer.eval(guiEnv+"$"+tmpData + " <- attributes(" +dataName+")");	
			}
		}catch(Exception e){e.printStackTrace();}
	
	}

	public JMenuBar generateMenuBar() {
		return new JMenuBar();
	}

	public void cleanUp() {
		boolean envDefined = ((REXPLogical)Deducer.eval("'"+guiEnv+"' %in% .getOtherObjects()")).isTRUE()[0];
		
		if(!envDefined){
			Deducer.eval(guiEnv+"<-new.env(parent=emptyenv())");
		}
		boolean tempStillExists = false;
		REXP tmp = Deducer.eval("exists('"+tmpData+"',where="+guiEnv+",inherits=FALSE)");
		if(tmp instanceof REXPLogical)
			tempStillExists = ((REXPLogical)tmp).isTRUE()[0];
		if(tempStillExists)
			Deducer.eval("rm("+tmpData+",envir="+guiEnv+")");	
	}

}
