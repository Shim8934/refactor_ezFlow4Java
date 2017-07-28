package egovframework.ezMobile.ezSchedule.vo;

public class MScheduleInfoVO {
	private String scheduleId;		/** 일정아이디 */
	
	private String creatorId;		/** 작성자아이디 */

	private String creatorName;		/** 작성자이름 */

	private String creatorName2;	/** 작성자영문이름 */
	
	private String createDate;		/** 작성일 */
	
	private String scheduleType;	/** 일정타입 : 개인,부서,회사등 */
	
	private String importance;		/** 중요도 */
	
	private String hasAttendant;	/** 참석자유무 */

	private String hasAttach;		/** 첨부파일유무 */
	
	private String startDate;		/** 일정시작일 */

	private String endDate;			/** 일정종료일 */
	
	private String title;			/** 일정제목 */
	
	private String location;		/** 일정위치 */
	
	private String contentPath;		/** content 경로 */

	public String getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(String scheduleId) {
		this.scheduleId = scheduleId;
	}

	public String getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}

	public String getCreatorName() {
		return creatorName;
	}

	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}

	public String getCreatorName2() {
		return creatorName2;
	}

	public void setCreatorName2(String creatorName2) {
		this.creatorName2 = creatorName2;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getScheduleType() {
		return scheduleType;
	}

	public void setScheduleType(String scheduleType) {
		this.scheduleType = scheduleType;
	}

	public String getImportance() {
		return importance;
	}

	public void setImportance(String importance) {
		this.importance = importance;
	}

	public String getHasAttendant() {
		return hasAttendant;
	}

	public void setHasAttendant(String hasAttendant) {
		this.hasAttendant = hasAttendant;
	}

	public String getHasAttach() {
		return hasAttach;
	}

	public void setHasAttach(String hasAttach) {
		this.hasAttach = hasAttach;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getContentPath() {
		return contentPath;
	}

	public void setContentPath(String contentPath) {
		this.contentPath = contentPath;
	}
	
}
