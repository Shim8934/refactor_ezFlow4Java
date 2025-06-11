package egovframework.ezEKP.ezSchedule.vo;

// 2025-03-20 조수빈 -일정 작성 시 일정대상을 선택하는 option 태그 생성 위한 vo
public class ScheduleOwnerInfoVO {
	
	// 스케쥴 타입 1-개인 2-부서 3- 회사 7-그룹 10-임원
	private String scheduleType;
	// 스케쥴오너아이디
	private String ownerId;
	// 스케쥴오너이름
	private String ownerName;
	// 스케쥴오너 다국어 이름
	private String ownerName2;

	public String getScheduleType() {
		return scheduleType;
	}

	public void setScheduleType(String scheduleType) {
		this.scheduleType = scheduleType;
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
}
