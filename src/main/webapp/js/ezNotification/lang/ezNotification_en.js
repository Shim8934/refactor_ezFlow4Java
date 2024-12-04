var mainType = {
	mail : "Mail",	
	approval : "Approval",	
	board : "Board",	
	schedule : "Schedule",
	resource : "Resource",
	survey : "Survey",
	poll : "Poll",
	community : "Community",
	webfolder : "Web folder",
	journal : "Work Journal",
	noti : "Notice",
	etc : "Etc"
}

var subType = {
	mail : {},
	approval : {
		arrive : "Document arrival",
		complete : "Document complete",
		reject : "Document return",
		receipt_reject : "Document return",
		pass : "Document passed",
		boryu : "Pending document",
		balsong : "Sending document",
		susin : "Received document",
		jijung : "Designated document",
		bebu : "Distribution document",
		rejijung : "Re-designation request",
		rebebu : "Re-distribution request",
		gongram : "Public document",
		circulation : "Circular document"
	},
	board : {
		modify : "Modification",
		comment : "New comment",
		reply : "New reply",
		apprv_waiting : "Waiting for approval"
	},
	schedule : {
		add : "Schedule invitation",
		cancel : "Cancel invitation",
		accept : "Invitation approved",
		reject : "Refusal of invitation",
		mod : "Modify schedule",
		reminder : "Reminder"
	},
	resource : {
		reserve : "Resource reservation",
		approve : "Resource approval",
		cancel : "Cancel approval",
		reject : "Approval denied"
	},
	survey:{},
	poll : {},
	community : {
		create_admit : "Creation approval",
		create_reject : "Creation rejected",
		apply : "Apply for membership",
		join : "New sign up",
		withdrawal : "Application for withdrawal",
		member_admit : "Subscription approval",
		member_reject : "Refusal to join",
		modify : "Modification notice",
		comment : "Post a comment",
		reply : "Reply notification",
		notice : "Full notice"
	},
	webfolder : {
		open_apply : "Application for opening",
		open_admit : "Approval for opening",
		open_reject : "Opening refused"
	},
	journal : {
		comment : "New comment",
		recv : "Received Journal"
	},
	noti : {
		emergency : "Emergency Notice"
	}
}

subType["approval"]["return"] = "Document withdraw";
subType["approval"]["default"] = "Approval Noti";
subType["board"]["new"] = "New posting";
subType["board"]["return"] = "Reject approval";
subType["schedule"]["delete"] = "Delete Schedule";
subType["survey"]["new"] = "New registration";
subType["poll"]["new"] = "New registration";
subType["community"]["new"] = "New registration";

var notiMessages = {
	strLang1 : '"No data."'
}

var notiDayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];