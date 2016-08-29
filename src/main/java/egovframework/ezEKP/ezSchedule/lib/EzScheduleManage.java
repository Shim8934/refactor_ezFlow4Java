package egovframework.ezEKP.ezSchedule.lib;

public interface EzScheduleManage {
	String InsertSchedule(String pOwnerID, String pOwnerName, String pOwnerName2, String pCreatorID, String pCreatorName, String pCreatorName2,
			String pScheduleType, String pImportance, String pIsPublic, String pDateType,
			String pStartDate, String pEndDate, String pRepetition, String pTitle, String pLocation, String pContent, String pAttachXML,
			String pAttendantXML, String pContentPath);
	
	String UpdateSchedule(String pScheduleID, String pModifierID, String pModifierName, String pModifierName2, 
			String pImportance, String pIsPublic, String pDateType,
			String pStartDate, String pEndDate, String pRepetition, String pTitle, String pLocation, String pContent, String pAttachXML,
			String pContentPath);
	
	String UpdateScheduleDate(String pScheduleID, String pStartDate, String pEndDate, String pModifierID, String pModifierName, String pModifierName2);
	
	String DeleteSchedule(String pScheduleID);
	
	String InsertAttendant(String pScheduleID, String pAttendantID, String pAttendantName, String pAttendantName2, String pAttendantDeptName, String pAttendantDeptName2);
	
	// 참석자 초대에서 제외하는 함수
	String DeleteAttendant(String pScheduleID, String pAttendantID);
	
	String UpdateAttendant(String pScheduleID, String pAttendantID, String pAttendantName, String pAttendantName2, String pStatus);
	
	String InsertComment(String pScheduleID, String pCommentorID, String pCommentorName, String pCommentorName2, String pComment);
	
	String DeleteComment(String pScheduleID, String pCommentID);
	
	String InsertScheduleGroupMember(String pGroupID, String pMemberXML);
	
	String DeleteScheduleMember(String pGroupID, String pMemberID);
	
	String UpdateScheduleMember(String pGroupID, String pMemberID, String pStatus);
	
	String DeleteScheduleGroup(String pGroupID);
	
	String InsertScheduleGroup(String pCreatorID, String pCreatorName, String pCreatorName2, String pGroupName,
			String pDescription, String pMemberXML);
	
	String InsertShare(String pOwnerID, String pOwnerName, String pOwnerName2, String pSharerID, String pSharerName, String pSharerName2, String pShareType, String pSharePermission);
	
	String DeleteShare(String pOwnerID, String pSharerID);
	
	String UpdateShare(String pOwnerID, String pSharerID, String pShareType, String pSharePermission);
	
	String UpdateConfigInfo(String pUserID, String pUserName, String pUserName2, String pDefaultView, String pStartDay, String pStartTime,
			String pEndTime, String pAutoDelete, String pSecretaryXML);
	
	String DeleteRepeatInstance(String pScheduleID, String pRepeatCount);
	
	String RestoreRepeatInstance(String pScheduleID);
	
	// Byte단위로 해당하는 문자열을 끊어주는 함수
	//private String LeftByte(String pOrgStr, int pLength);

    // 일정을 수정하는 함수
    String SimpleUpdateSchedule(String pScheduleID, String pModifierID, String pModifierName, String pModifierName2, String pTitle);

}
