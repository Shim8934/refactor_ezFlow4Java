var mainType = {
	mail : "メール",	
	approval : "決済",	
	board : "掲示板",	
	schedule : "スケジュール",
	resource : "リソース管理",
	survey : "アンケート",
	poll : "投票",
	community : "コミュニティ",
	webfolder : "Webフォルダ",
	journal : "業務日誌",
	noti : "お知らせ",
	etc : "その他"
}

var subType = {
	mail : {},
	approval : {
		arrive : "文書到着",
		complete : "文書完了",
		reject : "文書の搬送",
		receipt_reject : "回送文書",
		pass : "文書の通過",
		boryu : "文書保留",
		balsong : "文書を送る",
		susin : "受信文書",
		jijung : "指定文書",
		bebu : "配布文書",
		rejijung : "再指定要求",
		rebebu : "栽培要請",
		gongram : "公覧文書",
		circulation : "回覧文書"
	},
	board : {
		modify : "修正通知",
		comment : "コメント登録",
		reply : "回答登録",
		apprv_waiting : "承認待ち"
	},
	schedule : {
		add : "スケジュール招待",
		cancel : "招待キャンセル",
		accept : "招待承認",
		reject : "招待拒否",
		mod : "スケジュールを編集",
		reminder : "リマインダー"
	},
	resource : {
		reserve : "リソース予約",
		approve : "資源承認",
		cancel : "承認キャンセル",
		reject : "承認拒否"
	},
	survey:{},
	poll : {},
	community : {
		create_admit : "生成承認",
		create_reject : "生成拒否",
		apply : "登録申請",
		join : "新規登録",
		withdrawal : "退会申請",
		member_admit : "サインアップ承認",
		member_reject : "購読拒否",
		modify : "修正通知",
		comment : "コメント登録",
		reply : "回答通知",
		notice : "全通知"
	},
	webfolder : {
		open_apply : "開設申請",
		open_admit : "開設承認",
		open_reject : "開設拒否"
	},
	journal : {
		comment : "コメント登録",
		recv : "受信通知"
	},
	noti : {
		emergency : "緊急通知"
	}
}

subType["approval"]["return"] = "文書の回収";
subType["approval"]["default"] = "決済通知";
subType["board"]["new"] = "新規公開";
subType["board"]["return"] = "承認の返済";
subType["board"]["expired"] = "お知らせの掲載期間が終了";
subType["schedule"]["delete"] = "予定を削除";
subType["survey"]["new"] = "新規登録";
subType["poll"]["new"] = "新規登録";
subType["community"]["new"] = "新規登録";

var notiMessages = {
	strLang1 : '"没有数据."'
}

var notiDayNames = ["日", "月", "火", "水", "木", "金", "土"];
