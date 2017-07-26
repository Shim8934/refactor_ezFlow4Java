/**
 * 
 * @Description : 파일시스템 정보 
 * @Author : 오픈솔루션팀 박종균
 * 
 **/

package egovframework.ezEKP.ezSystem.vo;

public class FileSysInfoVO {
	/* File System */
	private String diskName;        // 파일시스템 이름
	private long totalVolume;       // 파일시스템 전체 용량
	private long usedVolume;        // 파일시스템 사용량
	private long freeVolume;        // 파일시스템 남은용량
	private long availVolume;       // 파일시스템 사용가능용량
	private double usedVolumePer;   // 파일시스템 사용량(%) 
	
	public String getDiskName() {
		return diskName;
	}
	public void setDiskName(String diskName) {
		this.diskName = diskName;
	}
	public long getTotalVolume() {
		return totalVolume;
	}
	public void setTotalVolume(long totalVolume) {
		this.totalVolume = totalVolume;
	}
	public long getUsedVolume() {
		return usedVolume;
	}
	public void setUsedVolume(long usedVolume) {
		this.usedVolume = usedVolume;
	}
	public long getFreeVolume() {
		return freeVolume;
	}
	public void setFreeVolume(long freeVolume) {
		this.freeVolume = freeVolume;
	}
	public long getAvailVolume() {
		return availVolume;
	}
	public void setAvailVolume(long availVolume) {
		this.availVolume = availVolume;
	}
	public double getUsedVolumePer() {
		return usedVolumePer;
	}
	public void setUsedVolumePer(double usedVolumePer) {
		this.usedVolumePer = usedVolumePer;
	}
	

}
