package egovframework.ezEKP.ezStatistics.vo;

import com.fasterxml.jackson.annotation.JsonProperty;
import org.apache.logging.log4j.util.Strings;

import java.util.List;

public class StatChartVO {
	@JsonProperty("labels")
	List<?> labels;
	@JsonProperty("datasets")
	List<Dataset> datasets;

	public static class Dataset {
		@JsonProperty("label")
		String label;
		@JsonProperty("data")
		List<?> data;
		@JsonProperty("type")
		String type;

		public Dataset(String label, List<?> data, String type) {
			this.label = label;
			this.data = data;
			this.type = type;
		}

		public Dataset(List<?> data) {
			this.data = data;
		}

		@Override
		public String toString() {
			return "Dataset{" +
					"label='" + label + '\'' +
					", data=" + data +
					", type='" + type + '\'' +
					'}';
		}
	}

	public void setLabels(List<?> labels) {
		this.labels = labels;
	}

	public void setDatasets(List<Dataset> datasets) {
		this.datasets = datasets;
	}

	@Override
	public String toString() {
		return "StatChartVO{" +
				"labels=" + labels +
				", datasets=" + datasets +
				'}';
	}
}
