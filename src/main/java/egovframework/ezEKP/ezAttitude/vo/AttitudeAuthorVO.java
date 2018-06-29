package egovframework.ezEKP.ezAttitude.vo;

public class AttitudeAuthorVO {
		/** 사용자 아이디 */
		private String userId;
	    /** 사용자 이름 */
	    private String userName;
	    /** 사용자 직위 */
	    private String jikwi;
	    /** 메일 */
	    private String mail;
	    /** 이미지 */
	    private String userImg;
	    /** 부서 아이디 */
	    private String deptId;
	    /** 부서명 */
	    private String deptName;
	    /** 자신의 부서인지(yes/no) */
	    private String mine;
	    /** 권한타입(R/M) */
	    private String authType;
	    /** 권한부서 아이디 */
		private String authDeptId;
		/** 권한부서명 */
		private String authDeptName;
		
		private String extensionAttribute15;
		
		public String getUserId() {
			return userId;
		}
		public void setUserId(String userId) {
			this.userId = userId;
		}
		public String getUserName() {
			return userName;
		}
		public void setUserName(String userName) {
			this.userName = userName;
		}
		public String getJikwi() {
			return jikwi;
		}
		public void setJikwi(String jikwi) {
			this.jikwi = jikwi;
		}
		public String getMail() {
			return mail;
		}
		public void setMail(String mail) {
			this.mail = mail;
		}
		public String getUserImg() {
			return userImg;
		}
		public void setUserImg(String userImg) {
			this.userImg = userImg;
		}
		public String getDeptId() {
			return deptId;
		}
		public void setDeptId(String deptId) {
			this.deptId = deptId;
		}
		public String getDeptName() {
			return deptName;
		}
		public void setDeptName(String deptName) {
			this.deptName = deptName;
		}
		public String getMine() {
			return mine;
		}
		public void setMine(String mine) {
			this.mine = mine;
		}
		public String getAuthType() {
			return authType;
		}
		public void setAuthType(String authType) {
			this.authType = authType;
		}
		public String getAuthDeptId() {
			return authDeptId;
		}
		public void setAuthDeptId(String authDeptId) {
			this.authDeptId = authDeptId;
		}
		public String getAuthDeptName() {
			return authDeptName;
		}
		public void setAuthDeptName(String authDeptName) {
			this.authDeptName = authDeptName;
		}
		public String getExtensionAttribute15() {
			return extensionAttribute15;
		}
		public void setExtensionattribute2(String extensionAttribute15) {
			this.extensionAttribute15 = extensionAttribute15;
		}
}
