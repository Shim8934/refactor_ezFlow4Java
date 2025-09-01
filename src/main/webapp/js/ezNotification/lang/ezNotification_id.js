var mainType = {
	mail : "메일",	
	approval : "Persetujuan",	
	board : "papan peringatan",	
	schedule : "jadwal",
	resource : "Pengelolaan sumber daya",
	survey : "survei",
	poll : "Pilih",
	community : "masyarakat",
	webfolder : "folder web",
	journal : "Jurnal Kerja",
	noti : "Pemberitahuan",
	etc : "dll."
}

var subType = {
	mail : {},
	approval : {
		arrive : "Kedatangan dokumen",
		complete : "Dokumen selesai",
		reject : "Pengembalian dokumen",
		receipt_reject : "dokumen pengembalian",
		pass : "Dokumen lulus",
		boryu : "Pegang dokumen",
		balsong : "Mengirim dokumen",
		susin : "Dokumen yang diterima",
		jijung : "Dokumen yang ditunjuk",
		bebu : "Dokumen distribusi",
		rejijung : "Permintaan penunjukan ulang",
		rebebu : "Permintaan redistribusi",
		gongram : "dokumen publik",
		circulation : "dokumen melingkar"
	},
	board : {
		modify : "Pemberitahuan modifikasi",
		comment : "Tulis komentar",
		reply : "Daftarkan balasan",
		apprv_waiting : "Menunggu persetujuan"
	},
	schedule : {
		add : "Jadwalkan undangan",
		cancel : "membatalkan undangan",
		accept : "Undangan disetujui",
		reject : "Penolakan undangan",
		mod : "Ubah jadwal",
		reminder : "Pengingat"
	},
	resource : {
		reserve : "Reservasi sumber daya",
		approve : "Persetujuan sumber daya",
		cancel : "Batalkan persetujuan",
		reject : "Persetujuan ditolak"
	},
	survey:{},
	poll : {},
	community : {
		create_admit : "Persetujuan penciptaan",
		create_reject : "Penciptaan ditolak",
		apply : "Ajukan permohonan keanggotaan",
		join : "Pendaftaran baru",
		withdrawal : "Aplikasi untuk penarikan",
		member_admit : "Persetujuan berlangganan",
		member_reject : "Penolakan untuk bergabung",
		modify : "Pemberitahuan modifikasi",
		comment : "Tulis komentar",
		reply : "Balasan pemberitahuan",
		notice : "Pemberitahuan penuh",
		invite : "Pemberitahuan undangan"
	},
	webfolder : {
		open_apply : "Aplikasi untuk pembukaan",
		open_admit : "Persetujuan pembukaan",
		open_reject : "Pembukaan ditolak"
	},
	journal : {
		comment : "Tulis komentar",
		recv : "Pemberitahuan Penerimaan"
	},
	noti : {
		emergency : "Pemberitahuan Darurat"
	}
}

subType["approval"]["return"] = "Pemulihan dokumen";
subType["approval"]["default"] = "Notifikasi Persetujuan";
subType["board"]["new"] = "Postingan baru";
subType["board"]["return"] = "Tolak persetujuan";
subType["board"]["expired"] = "Periode pengumuman telah berakhir";
subType["schedule"]["delete"] = "Hapus acara";
subType["survey"]["new"] = "Pendaftaran baru";
subType["poll"]["new"] = "Pendaftaran baru";
subType["community"]["new"] = "Pendaftaran baru";

var notiMessages = {
	strLang1 : '"No data."'
}

var notiDayNames = ["Mg", "Sn", "Sl", "Rb", "Km", "Jm", "Sb"];
