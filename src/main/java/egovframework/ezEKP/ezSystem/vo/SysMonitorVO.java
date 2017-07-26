/**
 * 
 * @Description : 시스템 모니터링
 * @Author : 오픈솔루션팀 박종균
 * 
 **/

package egovframework.ezEKP.ezSystem.vo;

public class SysMonitorVO {
	
	/* Operating System */
	private String osName;          // 운영체제 이름
	private String osVer;           // 운영체제 버전
	
	/* Server */
	private String connectYN;       // 서버 연결 여부
	private String serverName;      // 서버 이름
	private String serverVer;       // 서버 버전
	
	/* CPU */
	private double userUsedCpu;     // 유저 사용량
	private double sysUsedCpu;      // 시스템 사용량
	private double freeCpu;         // 미사용량
	private double totalUsedCpu;    // 총 사용량
	
	/* Memory */
	private long totalMemory;       // 메모리 전체 용량
	private long usedMemory;        // 메모리 사용량
	private long freeMemory;        // 메모리 미사용량
	private double usedMemPer;      // 메모리 사용량(%)
	private double freeMemPer;      // 메모리 미사용량(%)
	
	/* Network */
	private String netInter;        // 인터페이스이름
	private long currentRx;         // 수신량
	private long currentTx;         // 송신량
	
	public String getOsName() {
		return osName;
	}
	public void setOsName(String osName) {
		this.osName = osName;
	}
	public String getOsVer() {
		return osVer;
	}
	public void setOsVer(String osVer) {
		this.osVer = osVer;
	}
	public String getConnectYN() {
		return connectYN;
	}
	public void setConnectYN(String connectYN) {
		this.connectYN = connectYN;
	}
	public String getServerName() {
		return serverName;
	}
	public void setServerName(String serverName) {
		this.serverName = serverName;
	}
	public String getServerVer() {
		return serverVer;
	}
	public void setServerVer(String serverVer) {
		this.serverVer = serverVer;
	}
	public double getUserUsedCpu() {
		return userUsedCpu;
	}
	public void setUserUsedCpu(double userUsedCpu) {
		this.userUsedCpu = userUsedCpu;
	}
	public double getSysUsedCpu() {
		return sysUsedCpu;
	}
	public void setSysUsedCpu(double sysUsedCpu) {
		this.sysUsedCpu = sysUsedCpu;
	}
	public double getFreeCpu() {
		return freeCpu;
	}
	public void setFreeCpu(double freeCpu) {
		this.freeCpu = freeCpu;
	}
	public double getTotalUsedCpu() {
		return totalUsedCpu;
	}
	public void setTotalUsedCpu(double totalUsedCpu) {
		this.totalUsedCpu = totalUsedCpu;
	}
	public long getTotalMemory() {
		return totalMemory;
	}
	public void setTotalMemory(long totalMemory) {
		this.totalMemory = totalMemory;
	}
	public long getUsedMemory() {
		return usedMemory;
	}
	public void setUsedMemory(long usedMemory) {
		this.usedMemory = usedMemory;
	}
	public long getFreeMemory() {
		return freeMemory;
	}
	public void setFreeMemory(long freeMemory) {
		this.freeMemory = freeMemory;
	}
	public double getUsedMemPer() {
		return usedMemPer;
	}
	public void setUsedMemPer(double usedMemPer) {
		this.usedMemPer = usedMemPer;
	}
	public double getFreeMemPer() {
		return freeMemPer;
	}
	public void setFreeMemPer(double freeMemPer) {
		this.freeMemPer = freeMemPer;
	}
	public String getNetInter() {
		return netInter;
	}
	public void setNetInter(String netInter) {
		this.netInter = netInter;
	}
	public long getCurrentRx() {
		return currentRx;
	}
	public void setCurrentRx(long currentRx) {
		this.currentRx = currentRx;
	}
	public long getCurrentTx() {
		return currentTx;
	}
	public void setCurrentTx(long currentTx) {
		this.currentTx = currentTx;
	}	
}
