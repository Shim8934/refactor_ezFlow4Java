package egovframework.ezEKP.ezEmail.type;

import java.util.EnumSet;

/**
 * 기존 String CMD 로 구분하던 것을 enum 상수화 함.
 * @see {@link https://sedangdang.tistory.com/240} 상수 대신 Enum을 사용하라
 *
 * 다형성을 사용하기 위한 방안으로,
 * 상속이 아닌 enum을 쓴 이유는 종류가 22개나 되기 때문이다.
 * 더 좋은 방법이 있다면, 수정 또는 주석으로 to-do 추가 바람!
 */
public enum WriteType {
	// 메일쓰기 (default: ""=NEW)
	  NEW             ()

	// 임시보관함	:EDIT_IN_DRAFTS, RESERVE 경우가 아닌 EDIT도 있을까..?
	, EDIT            (Category.EDIT, 	null)
	// EDIT && folderPath 임시보관함
	, EDIT_IN_DRAFTS  (Category.EDIT, 	null)
	// EDIT && !cdoMessageID
	, RESERVE         (Category.EDIT, 	null)

	// 재작성	:보낸편지함이 아닌 경우도 있을까..?
	, RESEND          (Category.RESEND,null)
	// RESEND && folderPath 보낸편지함
	, RESEND_IN_SENT  (Category.RESEND,null)

	// 회신
	, REPLY           (Category.REPLY, "ezEmail.t511")
	// 전체회신
	, REPLYALL        (Category.REPLY, "ezEmail.t511")

	// 전달
	, FORWARD         (Category.FORWARD, "ezEmail.t513")

	, READ            ()

// [module]
	// 게시판: 메일쓰기(게시발송)
	, BOARD           (Category.BOARD)
	, BOARDDOTNET     (Category.BOARD)
	// 커뮤니티
	, COMMUNITY       (Category.COMMUNITY)
	, COMMUNITYDOTNET (Category.COMMUNITY)
	// approvalG
	, DOCSEND         (Category.DOCSEND)
	, DOCSENDDOTNET   (Category.DOCSEND)
	// 업무일지
	, JOURNAL         (Category.JOURNAL)
	// ezPMS
	, EZPMS           (Category.EZPMS)
	// ezPMS 게시판
	, EZPMSBOARD      (Category.EZPMS)
	// 근태관리
	, ATTITUDE        (Category.ATTITUDE)
	// 근태관리 미입력자 메일발송
	, ATTITUDEABSENTED(Category.ATTITUDE)
	// 투표
	, POLL            (Category.POLL)
// 아직 이 값으로는 받는 부분 없음
//	, DOCSENDDOC
//	, ACCESSNO
//	, REPORT
	;

	private final Category category; // 대분류
	private final String prefixCode; // 회신: "ezEmail.t511", 전달: "ezEmail.t513"

	private enum Category {
		EDIT, RESEND, REPLY, FORWARD
		, BOARD, COMMUNITY, DOCSEND, JOURNAL, EZPMS, ATTITUDE, POLL;

		// 기존 메일을 사용하는 타입.
		public boolean useLoadFromOrigin() {
			return EnumSet.of(EDIT, RESEND, REPLY, FORWARD).contains(this); // useOriginalMessage() && useReplyMessage()
		}
		/**
		 * original Message를 그대로 재사용
		 *
		 * 1. 서명사용안함 default 여부가 이에 속한다.
		 * : 불러온 본문 텍스트가 현재 어떤 서명을 사용하고 있는지 알 수 없을 때.
		 *   기본서명설정에 값(content1)이 있더라도, 현재 선택상태를 서명사용안함으로 변경하는 작업.
		 * 1) 임시보관함의 메일을 수정할 때에는 서명사용안함이 default.
		 * 2) 메일 재전송할 때에는 서명사용안함이 default.
		 */
		public boolean useOriginalMessage() {
			return EnumSet.of(EDIT, RESEND).contains(this);
		}
		/**
		 * original Message를 → reply Message로 사용 (reply로 생성)
		 * : NEW + append reply
		 */
		public boolean useReplyMessage() {
			return EnumSet.of(REPLY, FORWARD).contains(this);
		}

		// 주소 세팅 여부 to, cc, bcc
		public boolean useSetAddresses() {
			return EnumSet.of(EDIT, RESEND, REPLY).contains(this);
		}
		// 첨부파일 로드 여부
		public boolean useAppendAttach() {
			return EnumSet.of(EDIT, RESEND, FORWARD).contains(this);
		}
		/**
		 * 임시보관함 이용
		 * : mailWrite.jsp> window.onbeforeunload> delDrafts(); 메일쓰기 창 닫을 시, 임시보관했던 메일 삭제 해줘야 함.
		 */
		public boolean useSaveDrafts() {
			return EnumSet.of(RESEND, REPLY, FORWARD).contains(this); // 아래서 RESERVE 추가할거임.
		}

		// 본문설정 무시 여부: 20190708 조진호 - 결재, 게시판, 커뮤니티에서 메일로 발송 시에는 textOption 무시
		public boolean ignoreTextOption() {
			return EnumSet.of(BOARD, COMMUNITY, DOCSEND).contains(this);
		}
	}

	WriteType() {
		this(null, null);
	}
	WriteType(Category category) {
		this(category, null);
	}
	WriteType(Category category, String prefixCode) {
//		this(category.useLoadFromOrigin(), category.useOriginalMessage(), category.useReplyMessage()
//		   , category.useSetAddresses(), category.useAppendAttach(), category.useSaveDrafts()
//		   , false, category, prefix);
//	}
//	WriteType(boolean useLoadFromOrigin, boolean useOriginalMessage, boolean useReplyMessage
//			, boolean useSetAddresses, boolean useAppendAttach, boolean useSaveDrafts, boolean ignoreTextOption
//			, Category category, String prefixCode) {
//
//		this.useLoadFromOrigin = useLoadFromOrigin;
//		this.useOriginalMessage = useOriginalMessage;
//		this.useReplyMessage = useReplyMessage;
//
//		this.useSetAddresses = useSetAddresses;
//		this.useAppendAttach = useAppendAttach;
//		this.useSaveDrafts = useSaveDrafts;
//		this.ignoreTextOption = ignoreTextOption; // [module]

		this.category = category;
		this.prefixCode = prefixCode;
	}

	/**
	 * [논리 단위 구분]
	 * : 다른 cmd에서도 사용하고 싶은 기능이 있다면 언제든 추가해서 사용할 수 있다!
	 */
	// 주소 클릭해서 메일쓰기
	public boolean useMsgToAsTo() {
		return this == NEW;
	}
	// 운영자에게 메일 보내기
	public boolean useOperatorMailAddress() {
		return this == NEW;
	}
	// unread
	public boolean useUnread() {
		return this == RESEND_IN_SENT;
	}
	// orgMessage.reply 할 때, Flags.Flag.ANSWERED를 true 할 것인지
	public boolean useReplyAnswered() {
		return this == REPLYALL;
	}
	// isPureAscii 사용할것인지
	public boolean useCheckForAscii() {
		return isResend() || isReply() || isReserve(); // 문제없으면.. 다 체크하던지 통일했으면 좋겠는데
	}

	// getter
	public boolean useLoadFromOrigin() {
		// return category.useLoadFromOrigin();
		return EnumSet.of(EDIT_IN_DRAFTS, RESERVE, RESEND_IN_SENT, REPLY, REPLYALL, FORWARD).contains(this); // 기존코드에서 왜 임시보관함, 보낸편지함으로 한정했을까?
	}
	public boolean useOriginalMessage() {
		return category != null && category.useOriginalMessage();
	}
	public boolean useReplyMessage() {
		return category != null && category.useReplyMessage();
	}
	public boolean useSetAddresses() {
		return category != null && category.useSetAddresses();
	}
	public boolean useAppendAttach() {
		return category != null && category.useAppendAttach();
	}
	public boolean useSaveDrafts() {
		return category != null && category.useSaveDrafts() || isReserve();
	}
	public boolean ignoreTextOption() {
		return category != null && category.ignoreTextOption();
	}
	public String getPrefixCode() {
		return prefixCode;
	}

	public boolean isEdit() { // 수정
		return category == Category.EDIT;
	}
	public boolean isResend() { // 재작성
		return category == Category.RESEND;
	}
	public boolean isReply() { // 회신
		return category == Category.REPLY;
	}
	public boolean isReserve() { // 예약발송관리 수정
		return this == RESERVE;
	}
	public boolean isDotNet() { // 닷넷
		return EnumSet.of(BOARDDOTNET, COMMUNITYDOTNET, DOCSENDDOTNET).contains(this);
	}
}
