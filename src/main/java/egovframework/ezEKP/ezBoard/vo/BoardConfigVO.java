package egovframework.ezEKP.ezBoard.vo;

public class BoardConfigVO {
	private String USERID;
	private int LISTCOUNT;
	private String PREVIEW;
	private int PREVIEWWLIST;
	private int PREVIEWWCONTENT;
	private int PREVIEWHLIST;
	private int PREVIEWHCONTENT;
	
	public BoardConfigVO() {
		
	}

	public String getUSERID() {
		return USERID;
	}

	public void setUSERID(String uSERID) {
		USERID = uSERID;
	}

	public int getLISTCOUNT() {
		return LISTCOUNT;
	}

	public void setLISTCOUNT(int lISTCOUNT) {
		LISTCOUNT = lISTCOUNT;
	}

	public String getPREVIEW() {
		return PREVIEW;
	}

	public void setPREVIEW(String pREVIEW) {
		PREVIEW = pREVIEW;
	}

	public int getPREVIEWWLIST() {
		return PREVIEWWLIST;
	}

	public void setPREVIEWWLIST(int pREVIEWWLIST) {
		PREVIEWWLIST = pREVIEWWLIST;
	}

	public int getPREVIEWWCONTENT() {
		return PREVIEWWCONTENT;
	}

	public void setPREVIEWWCONTENT(int pREVIEWWCONTENT) {
		PREVIEWWCONTENT = pREVIEWWCONTENT;
	}

	public int getPREVIEWHLIST() {
		return PREVIEWHLIST;
	}

	public void setPREVIEWHLIST(int pREVIEWHLIST) {
		PREVIEWHLIST = pREVIEWHLIST;
	}

	public int getPREVIEWHCONTENT() {
		return PREVIEWHCONTENT;
	}

	public void setPREVIEWHCONTENT(int pREVIEWHCONTENT) {
		PREVIEWHCONTENT = pREVIEWHCONTENT;
	}

	@Override
	public String toString() {
		return "BoardConfigVO [USERID=" + USERID + ", LISTCOUNT=" + LISTCOUNT
				+ ", PREVIEW=" + PREVIEW + ", PREVIEWWLIST=" + PREVIEWWLIST
				+ ", PREVIEWWCONTENT=" + PREVIEWWCONTENT + ", PREVIEWHLIST="
				+ PREVIEWHLIST + ", PREVIEWHCONTENT=" + PREVIEWHCONTENT + "]";
	}
	
	
	
}
