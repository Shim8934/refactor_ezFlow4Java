package egovframework.ezEKP.ezPMS.vo;

import java.util.List;

//업무 관련 VO
public class ProjectTaskVO {
	 // 업무 아이디 
    private Long taskId;

    // 테넌트 아이디 
    private int tenantId;

    // 프로젝트 아이디 
    private Long projectId;

    // 그룹 아이디 
    private Long groupId;

    // 업무 명 
    private String taskName;

    // 상태 
    private String status;

    // 계획 시작 일 
    private String planStartDate;

    // 계획 종료 일 
    private String planEndDate;

    // 실제 시작 일 
    private String realStartDate;

    // 실제 종료 일 
    private String realEndDate;

    // 실제 진행률 
    private Float realProgress;

    // 가중치 
    private Float weight;

    // 개요 
    private String overview;

    // 참여 인원수 
    private int memberCount;

    // 총괄 담당자 아이디 
    private String headManagerId;

    // 총괄 담당자 명 
    private String headManagerName;

    // 총괄 담당자 명다국어 
    private String headManagerName2;

    // 총괄 담당자 부서 
    private String headManagerDeptname;

    // 총괄 담당자 부서다국어 
    private String headManagerDeptname2;

    // 게시자 아이디 
    private String writerId;

    // 게시 일 
    private String writeDate;

    // 게시자 명 
    private String writerName;

    // 게시자 명다국어 
    private String writerName2;

    // 게시자 부서 
    private String writerDeptname;

    // 게시자 부서다국어 
    private String writerDeptname2;

    // 트리 깊이 
    private int treeDepth;

    // 조상 그룹 
    private String ancesterGroup;

    // 정렬 순서 
    private int sortOrder;

    // 업무일 
    private float workingday;

    // 남은 기한 
    private int restDueday;

    // 업무관리 업무 아이디 
    private Long linkTaskId;
    
    // 선행작업
    private String pretask;
    
    // 선행업무
    private String pregroup;

    // 삭제 상태 
    private int delStatus;
    
    // 업무 멤버
    private List<TaskMemberVO> taskMember;
    
    //그룹이름
    private String groupName;
    
    //프로젝트 이름
    private String projectName;
    
    //순수 task workingday
    private int realWorkingday;
    
    // 계획 진행률 
    private Float planProgress;
    
    // 조상 그룹을 포함한 선행 작업명
    private List<String> pretaskFullNames;
    
    // 선행작업명
    private List<String> pretaskNames;
    
    // 상위그룹의 treeDepth
    private int upperTreeDepth;
    
    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public Long getProjectId() {
        return projectId;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }

    public Long getGroupId() {
        return groupId;
    }

    public void setGroupId(Long groupId) {
        this.groupId = groupId;
    }

    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Float getRealProgress() {
        return realProgress;
    }

    public void setRealProgress(Float realProgress) {
        this.realProgress = realProgress;
    }

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public String getOverview() {
        return overview;
    }

    public void setOverview(String overview) {
        this.overview = overview;
    }

    public int getMemberCount() {
        return memberCount;
    }

    public void setMemberCount(int memberCount) {
        this.memberCount = memberCount;
    }

    public String getHeadManagerId() {
        return headManagerId;
    }

    public void setHeadManagerId(String headManagerId) {
        this.headManagerId = headManagerId;
    }

    public String getHeadManagerName() {
        return headManagerName;
    }

    public void setHeadManagerName(String headManagerName) {
        this.headManagerName = headManagerName;
    }

    public String getHeadManagerName2() {
        return headManagerName2;
    }

    public void setHeadManagerName2(String headManagerName2) {
        this.headManagerName2 = headManagerName2;
    }

    public String getHeadManagerDeptname() {
        return headManagerDeptname;
    }

    public void setHeadManagerDeptname(String headManagerDeptname) {
        this.headManagerDeptname = headManagerDeptname;
    }

    public String getHeadManagerDeptname2() {
        return headManagerDeptname2;
    }

    public void setHeadManagerDeptname2(String headManagerDeptname2) {
        this.headManagerDeptname2 = headManagerDeptname2;
    }

    public String getWriterId() {
		return writerId;
	}

	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}

	public String getWriterName() {
        return writerName;
    }

    public void setWriterName(String writerName) {
        this.writerName = writerName;
    }

    public String getWriterName2() {
        return writerName2;
    }

    public void setWriterName2(String writerName2) {
        this.writerName2 = writerName2;
    }

    public String getWriterDeptname() {
        return writerDeptname;
    }

    public void setWriterDeptname(String writerDeptname) {
        this.writerDeptname = writerDeptname;
    }

    public String getWriterDeptname2() {
        return writerDeptname2;
    }

    public void setWriterDeptname2(String writerDeptname2) {
        this.writerDeptname2 = writerDeptname2;
    }

    public int getTreeDepth() {
        return treeDepth;
    }

    public void setTreeDepth(int treeDepth) {
        this.treeDepth = treeDepth;
    }

    public String getAncesterGroup() {
        return ancesterGroup;
    }

    public void setAncesterGroup(String ancesterGroup) {
        this.ancesterGroup = ancesterGroup;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public float getWorkingday() {
        return workingday;
    }

    public void setWorkingday(float workingday) {
        this.workingday = workingday;
    }

    public int getRestDueday() {
        return restDueday;
    }

    public void setRestDueday(int restDueday) {
        this.restDueday = restDueday;
    }

    public Long getLinkTaskId() {
        return linkTaskId;
    }

    public void setLinkTaskId(Long linkTaskId) {
        this.linkTaskId = linkTaskId;
    }

    public int getDelStatus() {
        return delStatus;
    }

    public void setDelStatus(int delStatus) {
        this.delStatus = delStatus;
    }

	public String getPlanStartDate() {
		return planStartDate;
	}

	public void setPlanStartDate(String planStartDate) {
		this.planStartDate = planStartDate;
	}

	public String getPlanEndDate() {
		return planEndDate;
	}

	public void setPlanEndDate(String planEndDate) {
		this.planEndDate = planEndDate;
	}

	public String getRealStartDate() {
		return realStartDate;
	}

	public void setRealStartDate(String realStartDate) {
		this.realStartDate = realStartDate;
	}

	public String getRealEndDate() {
		return realEndDate;
	}

	public void setRealEndDate(String realEndDate) {
		this.realEndDate = realEndDate;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}

	public String getPretask() {
		return pretask;
	}

	public void setPretask(String pretask) {
		this.pretask = pretask;
	}

	public String getPregroup() {
		return pregroup;
	}

	public void setPregroup(String pregroup) {
		this.pregroup = pregroup;
	}

	public List<TaskMemberVO> getTaskMember() {
		return taskMember;
	}

	public void setTaskMember(List<TaskMemberVO> taskMember) {
		this.taskMember = taskMember;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public int getRealWorkingday() {
		return realWorkingday;
	}

	public void setRealWorkingday(int realWorkingday) {
		this.realWorkingday = realWorkingday;
	}

	public Float getPlanProgress() {
		return planProgress;
	}

	public void setPlanProgress(Float planProgress) {
		this.planProgress = planProgress;
	}

	public List<String> getPretaskNames() {
		return pretaskNames;
	}

	public void setPretaskNames(List<String> pretaskNames) {
		this.pretaskNames = pretaskNames;
	}

	public List<String> getPretaskFullNames() {
		return pretaskFullNames;
	}

	public void setPretaskFullNames(List<String> pretaskFullNames) {
		this.pretaskFullNames = pretaskFullNames;
	}

	public int getUpperTreeDepth() {
		return upperTreeDepth;
	}

	public void setUpperTreeDepth(int upperTreeDepth) {
		this.upperTreeDepth = upperTreeDepth;
	}
}
