package egovframework.ezEKP.ezApprovalG.vo;

public class ApprGSusinProcessInfoVO {
	private String aprState;
	
	private String processYN;
	
	private String processorId;

	private String processDocId;
	
	private String docstate;
	
	private String docId;
	
	private int tenantId;
	
	private String companyId;

	public String getAprState() {
		return aprState;
	}

	public void setAprState(String aprState) {
		this.aprState = aprState;
	}

	public String getProcessYN() {
		return processYN;
	}

	public void setProcessYN(String processYN) {
		this.processYN = processYN;
	}

	public String getProcessorId() {
		return processorId;
	}

	public void setProcessorId(String processorId) {
		this.processorId = processorId;
	}

	public String getDocstate() {
		return docstate;
	}

	public void setDocstate(String docstate) {
		this.docstate = docstate;
	}

	public String getDocId() {
		return docId;
	}

	public void setDocId(String docId) {
		this.docId = docId;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public String getProcessDocId() {
		return processDocId;
	}

	public void setProcessDocId(String processDocId) {
		this.processDocId = processDocId;
	}
	
}
