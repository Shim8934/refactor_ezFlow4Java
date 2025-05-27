package egovframework.ezEKP.ezCommunity.vo;

public class CommunityMemberGradeVO {
	/** 커뮤니티ID*/
	String c_ClubNo;
	/** 회원등급코드 : 1~10까지의 등급 존재 가능 (1:마스터, 2:운영자, 3:정회원, 4:준회원, ... , 10: 손님) */
	String gradeCode;
	/** 회원등급명*/
	String gradeName;
	/** 가입시초기등급코드 */
	String join_Grade;

	public String getC_ClubNo() {
		return c_ClubNo;
	}

	public void setC_ClubNo(String c_ClubNo) {
		this.c_ClubNo = c_ClubNo;
	}

	public String getGradeCode() {
		return gradeCode;
	}

	public void setGradeCode(String gradeCode) {
		this.gradeCode = gradeCode;
	}

	public String getGradeName() {
		return gradeName;
	}

	public void setGradeName(String gradeName) {
		this.gradeName = gradeName;
	}

	public String getJoin_Grade() {
		return join_Grade;
	}

	public void setJoin_Grade(String join_Grade) {
		this.join_Grade = join_Grade;
	}
}
