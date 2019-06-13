package egovframework.ezEKP.ezPMS.vo;

//프로젝트 참여자 관련 정보
public class ProjectGroupMemberVO {
	// 멤버 아이디 
    private Long memberId;

    // 테넌트 아이디 
    private int tenantId;

    // 멤버 역할 아이디 
    private int memberRoleId;

    // 그룹 아이디 
    private Long groupId;
    
    // 사용자 아이디 
    private String userId;

    // 사용자 명 
    private String userName;

    // 사용자 명다국어 
    private String userName2;

    // 사용자 부서 
    private String userDeptname;

    // 사용자 부서다국어 
    private String userDeptname2;

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public int getMemberRoleId() {
        return memberRoleId;
    }

    public void setMemberRoleId(int memberRoleId) {
        this.memberRoleId = memberRoleId;
    }

    public Long getGroupId() {
		return groupId;
	}

	public void setGroupId(Long groupId) {
		this.groupId = groupId;
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

    public String getUserDeptname() {
        return userDeptname;
    }

    public void setUserDeptname(String userDeptname) {
        this.userDeptname = userDeptname;
    }

    public String getUserDeptname2() {
        return userDeptname2;
    }

    public void setUserDeptname2(String userDeptname2) {
        this.userDeptname2 = userDeptname2;
    }
}
