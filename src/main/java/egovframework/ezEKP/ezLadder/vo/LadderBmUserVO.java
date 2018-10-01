package egovframework.ezEKP.ezLadder.vo;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class LadderBmUserVO {
	/** 테넌트 id */
	private int tenant_id;
	/** 사다리 즐겨찾기 번호 */
	private int ladderBmId;
	/** 해당 ladderBmId를 작성한 유저 */
	private String writerId;
	/** 즐겨찾기에 포함된 멤버 아이디 */
	private String userId;
	/** 즐겨찾기에 포함된 멤버 이름  */
	private String userName;
	/** 즐겨찾기에 포함된 멤버 이름 (다국어)*/
	private String userName2;
	/** 다국어 설정 */
	private String lang;
	/** 회사 아이디  */
	private String companyID;
	/** 회사 이름  */
	private String company;
	/** 부서 아이디 */
	private String deptID;
	private String description;
	private String description2;
	/** 이메일 */
	private String mail;
	/** pic 저장소 */
	private String pic;
	
	/** 즐겨찾기에 포함된 멤버 아이디 */
	private String [] userIds;
	/** 즐겨찾기에 포함된 멤버 이름  */
	private String [] userNames;
	/** 즐겨찾기에 포함된 멤버 이름 (다국어)*/
	private String [] userName2s;
	/** 즐겨찾기에 포함된 부서이름*/
	private String [] descriptions;
	/** 즐겨찾기에 포함된 부서이름 (다국어) */
	private String [] descriptions2;
	
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public String getDeptID() {
		return deptID;
	}
	public void setDeptID(String deptID) {
		this.deptID = deptID;
	}
	public int getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(int tenant_id) {
		this.tenant_id = tenant_id;
	}
	public int getLadderBmId() {
		return ladderBmId;
	}
	public void setLadderBmId(int ladderBmId) {
		this.ladderBmId = ladderBmId;
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
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
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	
	/** 배열 */

	public String[] getUserIds() {
		return userIds;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDescription2() {
		return description2;
	}
	public void setDescription2(String description2) {
		this.description2 = description2;
	}
	public String[] getDescriptions() {
		return descriptions;
	}
	public void setDescriptions(String[] descriptions) {
		this.descriptions = descriptions;
	}
	public String[] getDescriptions2() {
		return descriptions2;
	}
	public void setDescriptions2(String[] descriptions2) {
		this.descriptions2 = descriptions2;
	}
	public void setUserIds(String[] userIds) {
		this.userIds = userIds;
	}
	public String[] getUserNames() {
		return userNames;
	}
	public void setUserNames(String[] userNames) {
		this.userNames = userNames;
	}
	public String[] getUserName2s() {
		return userName2s;
	}
	public void setUserName2s(String[] userName2s) {
		this.userName2s = userName2s;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company == null ? "" : company;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail == null ? "" : mail;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic == null ? "" : pic;
	}
	
	@Override
	public String toString() {
		return "LadderBmUserVO [tenant_id=" + tenant_id + ", ladderBmId="
				+ ladderBmId + ", writerId=" + writerId + ", userId=" + userId
				+ ", userName=" + userName + ", userName2=" + userName2
				+ ", lang=" + lang + ", userIds=" + Arrays.toString(userIds)
				+ ", userNames=" + Arrays.toString(userNames) + ", userName2s="
				+ Arrays.toString(userName2s) + "]";
	}
}
