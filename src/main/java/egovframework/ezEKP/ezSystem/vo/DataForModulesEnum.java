package egovframework.ezEKP.ezSystem.vo;

public enum DataForModulesEnum {
	MAIL("^james|^jmocha", "", new String [] {"upload_mail.ROOT"}), 
	SCHEDULE("^tbl_schedule|^tbl_task", "code|deptinfo|category", new String [] {"upload_schedule.ROOT", "upload_task.ROOT"}),
	APPROVAL("^tbl_([_a-z])*apr|^tbl_tmp|^tbl_([_a-z])*cab|^tbl_form|^tbl_last|^tbl_audio|^tbl_([_a-z])*receipt|^tbl_(my)?task([_a-z])*(code|deptinfo|category)|^tbl_(rec|([_a-z]*rec$))"
			+ "|^tbl_(lin|dept)([_a-z])*templet|^tbl_usercont|^tbl_([_a-z])*doc|^tbl_history|^tbl_end|^v[(a-z)]*(apr|doc|task)|^tbl_seperate|^tbl_([_a-z])*container|tbl_serialnumgen|tbl_notification"
			+ "|tbl_codelist|^tbl_([_a-z])*sign|^tbl_([_a-z])*special", "_cb_", new String [] {"upload_approvalG.ROOT"}),
	BOARD("^tbl_board|^tbl_photo|^tbl_poll|^tbl_qs", "", new String [] {"upload_board.ROOT"}), 
	COMMUNITY("^tbl_c_|^tbl_comm|^tbl_club", "", new String [] {"upload_community.ROOT"}), 
	RESOURCE("^tbl_rs", "", null);
	
	final private String tableName;
	final private String notTableName;
	final private String [] filerootName;
	
	private DataForModulesEnum(String tableName, String notTableName, String [] filerootName) {
		this.tableName = tableName;
		this.notTableName = notTableName;
		this.filerootName = filerootName;
	}
	
	public String getTableName() {
		return tableName;
	}
	
	public String [] getFilerootName() {
		return filerootName;
	}
	
	public String getNotTableName() {
		return notTableName;
	}
}
