package egovframework.ezEKP.ezSystem.vo;

public enum DataForModulesEnum {
	MAIL("^james|^jmocha", new String [] {"upload_mail.ROOT"}), 
	SCHEDULE("^tbl_schedule|^tbl_task", new String [] {"upload_schedule.ROOT", "upload_task.ROOT"}),
	APPROVAL("^tbl_([a-z])*apr|^tbl_tmp|^tbl_([a-z])*cabinet|^tbl_form|^tbl_last|^TBL_AUDIO|^tbl_receipt", new String [] {"upload_approvalG.ROOT"}), //테이블이 너무 다양해서 더 찾아봐야함...
	BOARD("^tbl_board|^tbl_photo|^tbl_poll|^tbl_qs", new String [] {"upload_board.ROOT"}), 
	COMMUNITY("^tbl_c_|^tbl_comm|^tbl_club", new String [] {"upload_community.ROOT"}), 
	RESOURCE("^tbl_rs", null);
	
	final private String tableName;
	final private String [] filerootName;
	
	private DataForModulesEnum(String tableName, String [] filerootName) {
		this.tableName = tableName;
		this.filerootName = filerootName;
	}
	
	public String getTableName() {
		return tableName;
	}
	
	public String [] getFilerootName() {
		return filerootName;
	}
}
