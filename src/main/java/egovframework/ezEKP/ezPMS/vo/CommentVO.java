package egovframework.ezEKP.ezPMS.vo;

public class CommentVO {
		// 의견 아이디
		private int commentId;
		
		// 테넌트 아이디
		private int tenantId;
		
		// 게시자 아이디
		private String writerId;
		
		// 게시 내용
		private String commentContent;
		
		// 게시일
		private String writeDate;
		
		// 게시 수정일
		private String updateDate;
		
		// 업무 아이디
		private Long taskId;
		
		// 그룹 아이디
		private Long groupId;
		
		// 프로젝트 아이디
		private Long projectId;
		
		// 게시자 명
		private String writerName;
		
		// 게시자 명 다국어
		private String writerName2;
		
		// 게시자 부서
		private String writerDeptName;
		
		// 게시자 부서 다국어
		private String writerDeptName2;
		
		// 게시자 직위
		private String writerPosition;
		
		// 게시자 직위 다국어
		private String writerPosition2;
		
		// 업무 명
		private String taskName;
		
		// 그룹 명
		private String groupName;
		
		// 프로젝트 명
		private String projectName;

		public int getCommentId() {
			return commentId;
		}

		public void setCommentId(int commentId) {
			this.commentId = commentId;
		}

		public int getTenantId() {
			return tenantId;
		}

		public void setTenantId(int tenantId) {
			this.tenantId = tenantId;
		}

		public String getWriterId() {
			return writerId;
		}

		public void setWriterId(String writerId) {
			this.writerId = writerId;
		}

		public String getCommentContent() {
			return commentContent;
		}

		public void setCommentContent(String commentContent) {
			this.commentContent = commentContent;
		}

		public String getWriteDate() {
			return writeDate;
		}

		public void setWriteDate(String writeDate) {
			this.writeDate = writeDate;
		}

		public String getUpdateDate() {
			return updateDate;
		}

		public void setUpdateDate(String updateDate) {
			this.updateDate = updateDate;
		}

		public Long getTaskId() {
			return taskId;
		}

		public void setTaskId(Long taskId) {
			this.taskId = taskId;
		}

		public Long getGroupId() {
			return groupId;
		}

		public void setGroupId(Long groupId) {
			this.groupId = groupId;
		}

		public Long getProjectId() {
			return projectId;
		}

		public void setProjectId(Long projectId) {
			this.projectId = projectId;
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

		public String getWriterDeptName() {
			return writerDeptName;
		}

		public void setWriterDeptName(String writerDeptName) {
			this.writerDeptName = writerDeptName;
		}

		public String getWriterDeptName2() {
			return writerDeptName2;
		}

		public void setWriterDeptName2(String writerDeptName2) {
			this.writerDeptName2 = writerDeptName2;
		}

		public String getWriterPosition() {
			return writerPosition;
		}

		public void setWriterPosition(String writerPosition) {
			this.writerPosition = writerPosition;
		}

		public String getWriterPosition2() {
			return writerPosition2;
		}

		public void setWriterPosition2(String writerPosition2) {
			this.writerPosition2 = writerPosition2;
		}

		public String getTaskName() {
			return taskName;
		}

		public void setTaskName(String taskName) {
			this.taskName = taskName;
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
}
