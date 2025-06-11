package egovframework.ezMobile.ezSchedule.vo;

public class MScheduleInfoVO {
	private String scheduleId;					/** 일정Id */
	
	private String parentId;					/** 부모일정Id */
		
	private String ownerId;						/** 소유자Id */

	private String ownerName;					/** 소유자이름 */	

	private String ownerName2;					/** 소유자이름2 */

	private String creatorId;					/** 등록자Id */

	private String creatorName;					/** 등록자이름 */

	private String creatorName2;				/** 등록자이름2 */

	private String createDate;					/** 등록일 */

	private String modifierId;					/** 수정자Id */

	private String modifierName;				/** 수정자이름 */

	private String modifierName2;				/** 수정자이름2 */

	private String modifyDate;					/** 수정일 */

	private String scheduleType;				/** 일정종류 (개인/부서/회사) */

	private String importance;					/** 중요도 */

	private String hasAttendant;				/** 참석자유무 */

	private String hasAttach;					/** 첨부파일유무 */

	private String hasComment;					/** 댓글유무 */

	private String isReadOnly;					/** 읽기전용유무 */

	private String isPublic;					/** 공개유무 */

	private String dateType;					/** 일정날짜형식 (1:날짜지정/2:하루종일/3:반복날짜지정) */

	private String startDate;					/** 일정시작일시 */

	private String endDate;						/** 일정종료일시 */

	private String repetition;					/** 반복데이터 */

	private String repetitionDel;				/** 반복일정중 삭제된 일시 */

	private String title;						/** 제목 */

	private String location;					/** 위치 */
	
	private String content;						/** 내용 */

	private String contentPath;					/** mht 파일 경로 */
	
	private int repeatCount;					/** 반복횟순 */
	
	private String scheduleFlag;				/** 일정 구분값 */
	
	private String showTop;
	
	public String getScheduleId() {
		return scheduleId;
	}

	public void setScheduleId(String scheduleId) {
		this.scheduleId = scheduleId;
	}	

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}

	public String getOwnerName() {
		return ownerName;
	}

	public void setOwnerName(String ownerName) {
		this.ownerName = ownerName;
	}

	public String getOwnerName2() {
		return ownerName2;
	}

	public void setOwnerName2(String ownerName2) {
		this.ownerName2 = ownerName2;
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

	public String getModifierId() {
		return modifierId;
	}

	public void setModifierId(String modifierId) {
		this.modifierId = modifierId;
	}

	public String getModifierName() {
		return modifierName;
	}

	public void setModifierName(String modifierName) {
		this.modifierName = modifierName;
	}

	public String getModifierName2() {
		return modifierName2;
	}

	public void setModifierName2(String modifierName2) {
		this.modifierName2 = modifierName2;
	}

	public String getModifyDate() {
		return modifyDate;
	}

	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
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

	public String getHasComment() {
		return hasComment;
	}

	public void setHasComment(String hasComment) {
		this.hasComment = hasComment;
	}

	public String getIsReadOnly() {
		return isReadOnly;
	}

	public void setIsReadOnly(String isReadOnly) {
		this.isReadOnly = isReadOnly;
	}

	public String getIsPublic() {
		return isPublic;
	}

	public void setIsPublic(String isPublic) {
		this.isPublic = isPublic;
	}

	public String getDateType() {
		return dateType;
	}

	public void setDateType(String dateType) {
		this.dateType = dateType;
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

	public String getRepetition() {
		return repetition;
	}

	public void setRepetition(String repetition) {
		this.repetition = repetition;
	}

	public String getRepetitionDel() {
		return repetitionDel;
	}

	public void setRepetitionDel(String repetitionDel) {
		this.repetitionDel = repetitionDel;
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

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getContentPath() {
		return contentPath;
	}

	public void setContentPath(String contentPath) {
		this.contentPath = contentPath;
	}

	public int getRepeatCount() {
		return repeatCount;
	}

	public void setRepeatCount(int repeatCount) {
		this.repeatCount = repeatCount;
	}

	public String getScheduleFlag() {
		return scheduleFlag;
	}

	public void setScheduleFlag(String scheduleFlag) {
		this.scheduleFlag = scheduleFlag;
	}
	
	public String getShowTop() {
		return showTop;
	}

	public void setShowTop(String showTop) {
		this.showTop = showTop;
	}

}
