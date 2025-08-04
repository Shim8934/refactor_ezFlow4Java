var mainType = {
	mail : "邮件",	
	approval : "赞同",	
	board : "公告栏",	
	schedule : "日程",
	resource : "资源管理",
	survey : "民意调查",
	poll : "投票",
	community : "社区",
	webfolder : "网络文件夹",
	journal : "工作日志",
	noti : "通告",
	etc : "ETC"
}

var subType = {
	mail : {},
	approval : {
		arrive : "文件到达",
		complete : "文件完成",
		reject : "文件返还",
		receipt_reject : "返回文件",
		pass : "文件通过",
		boryu : "持有文件",
		balsong : "发送文件",
		susin : "收到文件",
		jijung : "指定文件",
		bebu : "分发文件",
		rejijung : "重新指定请求",
		rebebu : "请求重新分发",
		gongram : "公开文件",
		circulation : "循环文件"
	},
	board : {
		modify : "修改通知",
		comment : "发表评论",
		reply : "注册回复",
		apprv_waiting : "等待批准"
	},
	schedule : {
		add : "安排邀请",
		cancel : "取消邀请",
		accept : "邀请已获批准",
		reject : "拒绝邀请",
		mod : "修改日程",
		reminder : "提醒"
			
	},
	resource : {
		reserve : "资源预留",
		approve : "资源审批",
		cancel : "取消批准",
		reject : "批准被拒绝"
	},
	survey:{},
	poll : {},
	community : {
		create_admit : "创建审批",
		create_reject : "创建被拒绝",
		apply : "申请会员资格",
		join : "新注册",
		withdrawal : "申请提款",
		member_admit : "认购批准",
		member_reject : "拒绝加入",
		modify : "修改通知",
		comment : "发表评论",
		reply : "回复通知",
		notice : "完整通知",
		invite : "邀请通知"
	},
	webfolder : {
		open_apply : "申请开业",
		open_admit : "批准开业",
		open_reject : "开门被拒绝"
	},
	journal : {
		comment : "发表评论",
		recv : "接收通知"
	},
	noti : {
		emergency : "紧急通知"
	}
}

subType["approval"]["return"] = "恢复付款文件";
subType["approval"]["default"] = "赞同警报";
subType["board"]["new"] = "新帖子";
subType["board"]["return"] = "拒绝批准";
subType["board"]["expired"] = "公告期限已结束";
subType["schedule"]["delete"] = "删除事件";
subType["survey"]["new"] = "新注册";
subType["poll"]["new"] = "新注册";
subType["community"]["new"] = "新注册";

var notiMessages = {
	strLang1 : '"没有数据."'
}

var notiDayNames = ["日", "一", "二", "三", "四", "五", "六"];