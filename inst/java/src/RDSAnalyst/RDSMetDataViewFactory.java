package RDSAnalyst;

import org.rosuda.deducer.data.DataViewerTab;
import org.rosuda.deducer.data.DataViewerTabFactory;

public class RDSMetDataViewFactory implements DataViewerTabFactory {

	public DataViewerTab makeViewerTab(String dataName) {
		return new RDSMetaDataView(dataName);
	}

}
