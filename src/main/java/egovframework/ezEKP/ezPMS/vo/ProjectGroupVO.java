package egovframework.ezEKP.ezPMS.vo;

import java.sql.Date;
import java.util.List;

public class ProjectGroupVO {
	// 그룹 아이디 
    private Long groupId;

    // 테넌트 아이디 
    private int tenantId;

    // 프로젝트 아이디 
    private Long projectId;

    // 그룹 명 
    private String groupName;

    // 상위 그룹 아이디 
    private Long upperGroupId;

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

    // 생성자 아이디 
    private String creatorId;

    // 생성 일 
    private String createDate;

    // 생성자 명 
    private String creatorName;

    // 생성자 명다국어 
    private String creatorName2;

    // 생성자 부서 
    private String creatorDeptname;

    // 생성자 부서다국어 
    private String creatorDeptname2;

    // 트리 깊이 
    private int treeDepth;

    // 조상 그룹 
    private String ancesterGroup;

    // 정렬 순서 
    private int sortOrder;

    // 삭제 상태 
    private int delStatus;

    // 업무일 
    private int workingday;

    // 남은 기한 
    private int restDueday;
    
    //프로젝트 이름
    private String projectName;
    
    //상위 그룹 이름
    private String upperGroupName;
    
    //그룹 멤버 리스트
    private List<ProjectGroupMemberVO> groupMember;
    
    //그룹 가중치
    private Float weight;
    
    // 계획 진행률 
    private Float planProgress;
    
    // 선행작업
    private String pretask;
    
    // 선행업무
    private String pregroup;
    
    // 선행 작업의 조상 그룹 아이디
    private String pretaskAncesterGroupIds;
    
    // 조상 그룹을 포함한 선행 작업명
    private String pretaskName;
    
    // 상위 그룹의 treeDepth
    private int upperTreeDepth;
    
    //하위 task 개수
    private int taskCount;
    
    public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public String getUpperGroupName() {
		return upperGroupName;
	}

	public void setUpperGroupName(String upperGroupName) {
		this.upperGroupName = upperGroupName;
	}

	public Long getGroupId() {
        return groupId;
    }

    public void setGroupId(Long groupId) {
        this.groupId = groupId;
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

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public Long getUpperGroupId() {
        return upperGroupId;
    }

    public void setUpperGroupId(Long upperGroupId) {
        this.upperGroupId = upperGroupId;
    }

    public Float getRealProgress() {
        return realProgress;
    }

    public void setRealProgress(Float realProgress) {
        this.realProgress = realProgress;
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

    public String getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }

    public String getCreatorName() {
        return creatorName;
    }

    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }

    public String getCreatorName2() {
        return creatorName2;
    }

    public void setCreatorName2(String creatorName2) {
        this.creatorName2 = creatorName2;
    }

    public String getCreatorDeptname() {
        return creatorDeptname;
    }

    public void setCreatorDeptname(String creatorDeptname) {
        this.creatorDeptname = creatorDeptname;
    }

    public String getCreatorDeptname2() {
        return creatorDeptname2;
    }

    public void setCreatorDeptname2(String creatorDeptname2) {
        this.creatorDeptname2 = creatorDeptname2;
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

    public int getDelStatus() {
        return delStatus;
    }

    public void setDelStatus(int delStatus) {
        this.delStatus = delStatus;
    }

    public int getWorkingday() {
        return workingday;
    }

    public void setWorkingday(int workingday) {
        this.workingday = workingday;
    }

    public int getRestDueday() {
        return restDueday;
    }

    public void setRestDueday(int restDueday) {
        this.restDueday = restDueday;
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

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public List<ProjectGroupMemberVO> getGroupMember() {
		return groupMember;
	}

	public void setGroupMember(List<ProjectGroupMemberVO> groupMember) {
		this.groupMember = groupMember;
	}

	public Float getWeight() {
		return weight;
	}

	public void setWeight(Float weight) {
		this.weight = weight;
	}

	public Float getPlanProgress() {
		return planProgress;
	}

	public void setPlanProgress(Float planProgress) {
		this.planProgress = planProgress;
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

	public String getPretaskName() {
		return pretaskName;
	}

	public void setPretaskName(String pretaskName) {
		this.pretaskName = pretaskName;
	}

	public String getPretaskAncesterGroupIds() {
		return pretaskAncesterGroupIds;
	}

	public void setPretaskAncesterGroupIds(String pretaskAncesterGroupIds) {
		this.pretaskAncesterGroupIds = pretaskAncesterGroupIds;
	}

	public int getUpperTreeDepth() {
		return upperTreeDepth;
	}

	public void setUpperTreeDepth(int upperTreeDepth) {
		this.upperTreeDepth = upperTreeDepth;
	}

	public int getTaskCount() {
		return taskCount;
	}

	public void setTaskCount(int taskCount) {
		this.taskCount = taskCount;
	}
}
