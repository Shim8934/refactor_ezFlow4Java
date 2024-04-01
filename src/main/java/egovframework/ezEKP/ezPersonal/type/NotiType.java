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
	// 게시판 신규 게시글 등록 시
	BOARD_NEW(3, 1),
	// 게시판 게시글 수정 시
	BOARD_MODIFY(3, 2),
	// 게시판 게시글 댓글 등록 시
	BOARD_COMMENT(3, 3),
	// 게시판 게시글 답변 등록 시
	BOARD_REPLY(3, 4)
	;
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

}
