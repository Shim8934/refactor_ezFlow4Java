package egovframework.ezEKP.ezResource.vo;

public class ResOccuVO {
	private String ownerId;
	private String brdNm;
	private int count;
	private long usageTime;
	private String companyID;
	private String startDate;
	private String endDate;
	private int num;
	private int pNum;
	private String occupancy;
	private String companyName;
	
	public String getOwnerId() {
		return ownerId;
	}
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public long getUsageTime() {
		return usageTime;
	}
	public void setUsageTime(long usageTime) {
		this.usageTime = usageTime;
	}
	public String getBrdNm() {
		return brdNm;
	}
	public void setBrdNm(String brdNm) {
		this.brdNm = brdNm;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getpNum() {
		return pNum;
	}
	public void setpNum(int pNum) {
		this.pNum = pNum;
	}
	public String getOccupancy() {
		return occupancy;
	}
	public void setOccupancy(String occupancy) {
		this.occupancy = occupancy;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public ResOccuVO(String ownerId, String brdNm, int count, long usageTime, String companyID, String startDate,
			String endDate, int num, int pNum, String occupancy, String companyName) {
		super();
		this.ownerId = ownerId;
		this.brdNm = brdNm;
		this.count = count;
		this.usageTime = usageTime;
		this.companyID = companyID;
		this.startDate = startDate;
		this.endDate = endDate;
		this.num = num;
		this.pNum = pNum;
		this.occupancy = occupancy;
		this.companyName = companyName;
	}
	public ResOccuVO() {
	}
	
}
