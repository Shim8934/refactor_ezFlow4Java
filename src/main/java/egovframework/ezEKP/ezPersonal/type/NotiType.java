package egovframework.ezEKP.ezPersonal.type;

import java.util.Arrays;

public enum NotiType {

	MAIL(1, 0),
	// 문서 도착시
	APPROVAL_ARRIVE(2, 1),
	// 문서 완료시
	APPROVAL_COMPLETE(2, 2),
	// 문서 반송시
	APPROVAL_REJECT(2, 3),
	// 문서 회수될 때
	APPROVAL_RETURN(2, 4),
	// 수신문서 회송될 때
	APPROVAL_RECEIPT_REJECT(2, 5),
	// 문서 통과시
	APPROVAL_PASS(2, 6),
	
	// 게시판 신규 게시글 등록 시 (즐겨찾기 게시판)
	BOARD_NEW(3, 1),
	// 게시판 게시글 수정 시 (즐겨찾기 게시판)
	BOARD_MODIFY(3, 2),
	// 게시판 게시글 댓글 등록 시
	BOARD_COMMENT(3, 3),
	// 게시판 게시글 답변 등록 시
	BOARD_REPLY(3, 4),
	// 게시판 게시글 승인 반려 시
	BOARD_RETURN(3, 5),
	
	// 일정 초대 알림
	SCHEDULE_ADD(4, 1),
	// 일정 초대 취소
	SCHEDULE_CANCEl(4, 2),
	// 일정 초대 승인
	SCHEDULE_ACCEPT(4, 3),
	// 일정 초대 거부
	SCHEDULE_REJECT(4, 4),
	// 초대 일정 수정
	SCHEDULE_MOD(4, 5),
	// 초대 일정 삭제
	SCHEDULE_DELETE(4, 6),
	// 일정 미리알림
	SCHEDULE_REMINDER(4, 7),
	
	// 자원관리 자원 승인
	RESOURCE_APPROVE(5, 1),
	// 자원관리 자원 승인 취소
	RESOURCE_CANCEL(5, 2),
	// 자원관리 자원 승인 거절
	RESOURCE_REJECT(5, 3),
	
	// 전자설문 신규등록
	SURVEY_NEW(6, 1),
	
	// 투표 신규등록
	POLL_NEW(7, 1),
	
	// 커뮤니티 가입승인
	COMMUNITY_MEMBER_ADMIT(8, 1),
	// 커뮤니티 가입거절
	COMMUNITY_MEMBER_REJECT(8, 2),
	// 커뮤니티 전체공지
	COMMUNITY_NOTICE(8, 3),
	// 커뮤니티 신규게시
	COMMUNITY_NEW(8, 4),
	// 커뮤니티 수정알림
	COMMUNITY_MODIFY(8, 5),
	// 커뮤니티 답변알림
	COMMUNITY_REPLY(8, 6),
	// 커뮤니티 댓글등록
	COMMUNITY_COMMENT(8, 7),
	
	// 웹폴더 개설승인
	WEBFOLDER_OPEN_ADMIT(9, 1),
	// 웹폴더 개설거절
	WEBFOLDER_OPEN_REJECT(9, 2),
	
	JOURNAL_RECV(10, 1),
	JOURNAL_COMMENT(10, 2)
	;

	private final int mainType;
	private final int subType;

	NotiType(int mainType, int subType) {
		this.mainType = mainType;
		this.subType = subType;
	}

	public static NotiType valueOf(int mainType, int subType) {
		return Arrays.stream(values()).filter(notiType -> notiType.mainType == mainType && notiType.subType == subType).findAny().orElseThrow(IllegalArgumentException::new);
	}

	public int mainType() {
		return mainType;
	}

	public int subType() {
		return subType;
	}
	
	public static NotiType fromString(String text) {
        for (NotiType notiType : NotiType.values()) {
            if (notiType.name().equalsIgnoreCase(text)) {
                return notiType;
            }
        }
        throw new IllegalArgumentException("No constant with name " + text + " found");
    }

}
