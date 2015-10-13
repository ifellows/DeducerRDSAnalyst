package RDSAnalyst;

import java.awt.BorderLayout;

import javax.swing.BorderFactory;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JPanel;

import org.rosuda.deducer.Deducer;
import org.rosuda.deducer.menu.SubsetDialog;
import org.rosuda.deducer.menu.SubsetPanel;
import org.rosuda.deducer.toolkit.VariableSelector;
import org.rosuda.deducer.widgets.DeducerWidget;

public class SubsetWidget extends JPanel implements DeducerWidget{

	protected String lastText = "";
	protected String defaultText = "";
	protected String title = null; 
	protected SubsetPanel sub;
	
	public SubsetWidget(VariableSelector v){
		BorderLayout thisLayout = new BorderLayout();
		this.setLayout(thisLayout);
		this.setBorder(BorderFactory.createTitledBorder("Subset"));
		sub = new SubsetPanel(v.getJComboBox());
		this.add(sub);
	}
	
	public void setModel(Object model) {
		sub.refreshComboBox();
		if(model!=null)
			sub.setText(model.toString());
		else
			sub.setText("");
	}

	public Object getModel() {
		return sub.getText();
	}

	public void setLastModel(Object model) {
		if(model!=null)
			lastText = model.toString();
		else
			lastText= "";
	}

	public void setDefaultModel(Object model) {
		if(model!=null)
			defaultText = model.toString();
		else
			defaultText= "";
	}

	public void resetToLast() {
		setModel(lastText);
	}

	public void reset() {
		setModel(defaultText);
	}

	public String getRModel() {
		return "\""+Deducer.addSlashes((String) getModel())+"\"";
	}

	public void setTitle(String t, boolean show) {
		title=t;
		if(t==null || !show)
			this.setBorder(BorderFactory.createEmptyBorder());
		else
			this.setBorder(BorderFactory.createTitledBorder(title));
	}

	public void setTitle(String t) {
		setTitle(t,false);
	}

	public String getTitle() {
		return title;
	}
	
	
	public static boolean isValidSubsetExp(String subset,String dataName){
		return SubsetDialog.isValidSubsetExp(subset, dataName);
	}
	
	public static void addToHistory(String subset,String dataName){
		SubsetDialog.addToHistory(dataName, subset);
	}

}
