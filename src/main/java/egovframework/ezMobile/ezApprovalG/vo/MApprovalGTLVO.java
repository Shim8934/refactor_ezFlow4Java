package egovframework.ezMobile.ezApprovalG.vo;

public class MApprovalGTLVO {
	/** 타임라인 타이틀*/
	private String title;
	/** 타임라인 시작*/
	private String startDate;
	/** 타임라인 모듈*/
	private String module;
	/** 타임라인 작성자 (일정관리는 enddate)*/
	private String writerName;
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getModule() {
		return module;
	}
	public void setModule(String module) {
		this.module = module;
	}
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}

}
