package egovframework.ezEKP.ezPMS.vo;

import java.sql.Date;
import java.util.List;

//프로젝트 정보 
public class ProjectInfoVO {
	
	    // 프로젝트 아이디 
	    private int projectId;

	    // 테넌트 아이디 
	    private int tenantId;

	    // 프로젝트 명 
	    private String projectName;

	    // 계획 시작 일 
	    private String planStartDate;

	    // 계획 종료 일 
	    private String planEndDate;

	    // 실제 시작 일 
	    private String realStartDate;

	    // 실제 종료 일 
	    private String realEndDate;

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

	    // 상태 
	    private String status;

	    // 진행률 
	    private Double progress;

	    // 개요 
	    private String overview;

	    // 가중치 입력 
	    private int weightInput;

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

	    // 업무일 
	    private float workingday;

	    // 남은 기한 
	    private int restDueday;

	    // 알림 메일 상태 
	    private int alamMailStatus;
	    
	    // 프로젝트 멤버
	    private List<ProjectMemberVO> projectMember;
	    
	    public int getProjectId() {
	        return projectId;
	    }

	    public void setProjectId(int projectId) {
	        this.projectId = projectId;
	    }

	    public int getTenantId() {
	        return tenantId;
	    }

	    public void setTenantId(int tenantId) {
	        this.tenantId = tenantId;
	    }

	    public String getProjectName() {
	        return projectName;
	    }

	    public void setProjectName(String projectName) {
	        this.projectName = projectName;
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

	    public String getStatus() {
	        return status;
	    }

	    public void setStatus(String status) {
	        this.status = status;
	    }

	    public Double getProgress() {
	        return progress;
	    }

	    public void setProgress(Double progress) {
	        this.progress = progress;
	    }

	    public String getOverview() {
	        return overview;
	    }

	    public void setOverview(String overview) {
	        this.overview = overview;
	    }

	    public int getWeightInput() {
	        return weightInput;
	    }

	    public void setWeightInput(int weightInput) {
	        this.weightInput = weightInput;
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

	    public int getAlamMailStatus() {
	        return alamMailStatus;
	    }

	    public void setAlamMailStatus(int alamMailStatus) {
	        this.alamMailStatus = alamMailStatus;
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

		public List<ProjectMemberVO> getProjectMember() {
			return projectMember;
		}

		public void setProjectMember(List<ProjectMemberVO> projectMember) {
			this.projectMember = projectMember;
		}

}
