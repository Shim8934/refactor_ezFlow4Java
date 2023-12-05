package egovframework.let.user.login.vo;

import java.io.Serializable;
import java.util.Date;
import java.util.Locale;

public class FidoAuthenticationVO implements Serializable {	

	/** fido session id */
	private String fidoSessionId;
	/** 사용자 ID */
	private String id;
	/** 사용자 IP정보 */
	private String ip;
	/** 사용자 접속 상태(성공: Y, 실패: N) */
	private String status;
	/** fido session 생성 및 요청 시간 */
	private String creatTime;
	/** 사용자 접속 session id */
	private String encryptId;
	/** RSA 암호화 password 변수 */
	private String encryptPassword;

	public String getFidoSessionId() {
		return fidoSessionId;
	}
	public void setFidoSessionId(String fidoSessionId) {
		this.fidoSessionId = fidoSessionId;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIp() {
		return ip;
	}	
	public void setCreatTime(String creatTime) {
		this.creatTime = creatTime;
	}
	public String getCreatTime() {
		return creatTime;
	}	
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getEncryptId() {
		return encryptId;
	}
	public void setEncryptId(String encryptId) {
		this.encryptId = encryptId;
	}
	public String getEncryptPass() {
		return encryptPassword;
	}
	public void setEncryptPass(String encryptPassword) {
		this.encryptPassword = encryptPassword;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}
