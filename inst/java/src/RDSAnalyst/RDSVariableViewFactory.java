package RDSAnalyst;

import org.rosuda.deducer.data.DataViewerTab;
import org.rosuda.deducer.data.DataViewerTabFactory;

public class RDSVariableViewFactory implements DataViewerTabFactory{

	public DataViewerTab makeViewerTab(String dataName) {
		return new RDSVariableView(dataName);
	}

}
