package egovframework.ezEKP.ezPMS.vo;

//프로젝트관리 메인 화면 환경설정
public class ProjectMainSettingVO {
	// 환경설정 아이디 
    private Long settingId;

    // 테넌트 아이디 
    private int tenantId;

    // 사용자 아이디 
    private String userId;

    // 화면 종류 
    private int viewType;

    // 진행률 색상 
    private String progressColor;

    // 완료 색상 
    private String completeColor;

    // 지연 색상 
    private String overdueColor;

    // 보류 색상 
    private String holdColor;
    
    //삭제 색상 
    private String deleteColor = "#dd3b3b";
    
    //대기 색상
    private String waitColor = "#a5a5a5";
    
    // 프로젝트 정렬 
    private int projectSort;
    
    // 리스트 개수 
    private int listNumber;
    
    // 메인화면 프로젝트 상태
    private String listProjectStatus;
    
    // 사용자 메일
    private String userMail;
    
    // 이름
    private String userName;
    
    // 이름 다국어
    private String userName2;
    
    public String getUserMail() {
		return userMail;
	}

	public void setUserMail(String userMail) {
		this.userMail = userMail;
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

	public Long getSettingId() {
        return settingId;
    }

    public void setSettingId(Long settingId) {
        this.settingId = settingId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getViewType() {
        return viewType;
    }

    public void setViewType(int viewType) {
        this.viewType = viewType;
    }

    public String getProgressColor() {
        return progressColor;
    }

    public void setProgressColor(String progressColor) {
        this.progressColor = progressColor;
    }

    public String getCompleteColor() {
        return completeColor;
    }

    public void setCompleteColor(String completeColor) {
        this.completeColor = completeColor;
    }

    public String getOverdueColor() {
        return overdueColor;
    }

    public void setOverdueColor(String overdueColor) {
        this.overdueColor = overdueColor;
    }

    public String getHoldColor() {
        return holdColor;
    }

    public void setHoldColor(String holdColor) {
        this.holdColor = holdColor;
    }

    public int getProjectSort() {
        return projectSort;
    }

    public void setProjectSort(int projectSort) {
        this.projectSort = projectSort;
    }

    public int getListNumber() {
        return listNumber;
    }

    public void setListNumber(int listNumber) {
        this.listNumber = listNumber;
    }

	public String getListProjectStatus() {
		return listProjectStatus;
	}

	public void setListProjectStatus(String listProjectStatus) {
		this.listProjectStatus = listProjectStatus;
	}

	public String getDeleteColor() {
		return deleteColor;
	}

	public void setDeleteColor(String deleteColor) {
		this.deleteColor = deleteColor;
	}

	public String getWaitColor() {
		return waitColor;
	}

	public void setWaitColor(String waitColor) {
		this.waitColor = waitColor;
	}
}
