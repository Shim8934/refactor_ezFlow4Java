var mainType = {
	mail : "메일",	
	approval : "결재",	
	board : "게시판",	
	schedule : "일정",
	resource : "자원관리",
	survey : "설문",
	poll : "투표",
	community : "커뮤니티",
	webfolder : "웹폴더",
	journal : "업무일지",
	noti : "공지알림",
	etc : "기타"
}

var subType = {
	mail : {},
	approval : {
		arrive : "문서도착",
		complete : "문서완료",
		reject : "문서반송",
		receipt_reject : "회송문서",
		pass : "기결재통과",
		boryu : "문서보류",
		balsong : "문서발송",
		susin : "수신문서",
		jijung : "지정문서",
		bebu : "배부문서",
		rejijung : "재지정요청",
		rebebu : "재배부요청",
		gongram : "공람문서",
		circulation : "회람문서"
	},
	board : {
		modify : "수정알림",
		comment : "댓글등록",
		reply : "답변등록",
		apprv_waiting : "승인대기"
	},
	schedule : {
		add : "일정초대",
		cancel : "초대취소",
		accept : "초대승인",
		reject : "초대거부",
		mod : "일정수정",
		reminder : "미리알림"
	},
	resource : {
		reserve : "자원예약",
		approve : "자원승인",
		cancel : "승인취소",
		reject : "승인거부"
	},
	survey:{},
	poll : {},
	community : {
		create_admit : "생성승인",
		create_reject : "생성거절",
		apply : "가입신청",
		join : "신규가입",
		withdrawal : "탈퇴신청",
		member_admit : "가입승인",
		member_reject : "가입거절",
		modify : "수정알림",
		comment : "댓글등록",
		reply : "답변알림",
		notice : "전체공지"
	},
	webfolder : {
		open_apply : "개설신청",
		open_admit : "개설승인",
		open_reject : "개설거절"
	},
	journal : {
		comment : "댓글등록",
		recv : "수신알림"
	},
	noti : {
		emergency : "긴급공지"
	}
}

subType["approval"]["return"] = "문서회수";
subType["approval"]["default"] = "결재노티";
subType["board"]["new"] = "신규게시";
subType["board"]["return"] = "승인반려";
subType["schedule"]["delete"] = "일정삭제";
subType["survey"]["new"] = "신규등록";
subType["poll"]["new"] = "신규등록";
subType["community"]["new"] = "신규게시";

var notiMessages = {
	strLang1 : '"데이터가 없습니다."',
}

var notiDayNames = ["일", "월", "화", "수", "목", "금", "토"];