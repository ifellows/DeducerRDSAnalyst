package RDSAnalyst;

import org.rosuda.deducer.data.DataViewerTab;
import org.rosuda.deducer.data.DataViewerTabFactory;


public class RDSDataViewFactory implements DataViewerTabFactory{

	public DataViewerTab makeViewerTab(String dataName) {
		return new RDSDataView(dataName);
	}

}
