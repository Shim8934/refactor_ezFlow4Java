var mainType = {
	mail : "메일",	
	approval : "Sự chấp thuận",	
	board : "bảng ghi chú",	
	schedule : "lịch trình",
	resource : "Quản lý nguồn tài nguyên",
	survey : "sự khảo sát",
	poll : "bỏ phiếu",
	community : "cộng đồng",
	webfolder : "thư mục web",
	journal : "Nhật ký công việc",
	noti : "Thông báo",
	etc : "vân vân"
}

var subType = {
	mail : {},
	approval : {
		arrive : "Tài liệu đến",
		complete : "Tài liệu hoàn tất",
		reject : "Trả lại tài liệu",
		receipt_reject : "Trả lại tài liệu",
		pass : "Tài liệu đã được thông qua",
		boryu : "Giữ tài liệu",
		balsong : "Gửi tài liệu",
		susin : "Đã nhận được tài liệu",
		jijung : "Tài liệu được chỉ định",
		bebu : "Tài liệu phân phối",
		rejijung : "Yêu cầu chỉ định lại",
		rebebu : "Yêu cầu phân phối lại",
		gongram : "tài liệu công cộng",
		circulation : "tài liệu tròn"
	},
	board : {
		modify : "Thông báo sửa đổi",
		comment : "Đăng bình luận",
		reply : "Đăng ký trả lời",
		apprv_waiting : "Chờ phê duyệt"
	},
	schedule : {
		add : "Lên lịch mời",
		cancel : "hủy lời mời",
		accept : "Lời mời đã được phê duyệt",
		reject : "Từ chối lời mời",
		mod : "Sửa đổi lịch trình",
		reminder : "Nhắc nhở"
	},
	resource : {
		reserve : "Dự trữ tài nguyên",
		approve : "Phê duyệt tài nguyên",
		cancel : "Hủy phê duyệt",
		reject : "Phê duyệt bị từ chối"
	},
	survey:{},
	poll : {},
	community : {
		create_admit : "Phê duyệt sáng tạo",
		create_reject : "Sáng tạo bị từ chối",
		apply : "Đăng ký thành viên",
		join : "Đăng ký mới",
		withdrawal : "Đơn xin rút tiền",
		member_admit : "Phê duyệt đăng ký",
		member_reject : "Từ chối tham gia",
		modify : "Thông báo sửa đổi",
		comment : "Đăng bình luận",
		reply : "Trả lời thông báo",
		notice : "Thông báo đầy đủ",
		invite : "Thông báo lời mời"
	},
	webfolder : {
		open_apply : "Đơn xin khai trương",
		open_admit : "Phê duyệt khai trương",
		open_reject : "Khai trương bị từ chối"
	},
	journal : {
		comment : "Đăng bình luận",
		recv : "Thông báo nhận"
	},
	noti : {
		emergency : "Thông báo khẩn cấp"
	}
}

subType["approval"]["return"] = "Thu hồi chứng từ thanh toán";
subType["approval"]["default"] = "Thông báo thanh toán";
subType["board"]["new"] = "bài đăng mới";
subType["board"]["return"] = "Từ chối phê duyệt";
subType["board"]["expired"] = "Thời hạn thông báo đã kết thúc";
subType["schedule"]["delete"] = "Xóa sự kiện";
subType["survey"]["new"] = "Đăng kí mới";
subType["poll"]["new"] = "Đăng kí mới";
subType["community"]["new"] = "Đăng kí mới";

var notiMessages = {
	strLang1 : "Dữ liệu bị thiếu"
}

var notiDayNames = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];