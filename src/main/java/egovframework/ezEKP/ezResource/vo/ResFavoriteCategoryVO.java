package egovframework.ezEKP.ezResource.vo;

import java.util.List;

public class ResFavoriteCategoryVO {
	/** 즐겨찾기 카테고리(분류) ID */
	private String catId;
	/** 즐겨찾기 카테고리(분류) 부모 계층 ID */
	private String topId;
	/** 테넌트 ID **/
	private int tenantId;
	/** 사용자 ID */
	private String userId;
	/** 카테고리 제목 */
	private String catName;
	/** 업데이트날자 */
	private String updateDate;
	/** 회사ID */
	private String companyid;
	/** 자원 보유 유무 */
	private String brdYn;
	/** 자식 계층 리스트 */
	private List<ResFavoriteCategoryVO> childList;
	
	public String getBrdYn() {
		return brdYn;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public void setBrdYn(String brdYn) {
		this.brdYn = brdYn;
	}
	public List<ResFavoriteCategoryVO> getChildList() {
		return childList;
	}
	public void setChildList(List<ResFavoriteCategoryVO> childList) {
		this.childList = childList;
	}
	public String getCatId() {
		return catId;
	}
	public void setCatId(String catId) {
		this.catId = catId;
	}
	public String getTopId() {
		return topId;
	}
	public void setTopId(String topId) {
		this.topId = topId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getCatName() {
		return catName;
	}
	public void setCatName(String catName) {
		this.catName = catName;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getCompanyid() {
		return companyid;
	}
	public void setCompanyid(String companyid) {
		this.companyid = companyid;
	}
	@Override
	public String toString() {
		return "ResFavoriteCategoryVO [catId=" + catId + ", catName=" + catName + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((catId == null) ? 0 : catId.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		ResFavoriteCategoryVO other = (ResFavoriteCategoryVO) obj;
		if (catId == null) {
			if (other.catId != null) {
				return false;
			}
		} else if (!catId.equals(other.catId)) {
			return false;
		}
		return true;
	}
}