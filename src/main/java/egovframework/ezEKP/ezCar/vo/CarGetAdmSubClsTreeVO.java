package egovframework.ezEKP.ezCar.vo;

public class CarGetAdmSubClsTreeVO {
	/** 자원 번호*/
	private int carID;
	/** 자원 이름*/
	private String carName;
	/** 자원 번호 2*/
	private String carName2;
	/** 자원 레벨*/
	private int carLevel;
	/** 자원 순서*/
	private int carStep;
	/** 상위 자원 ID*/
	private int carUpper;
	/** 게시구분*/
	private String carGb;
	/** 접근 거부 메시지*/
	private String carAccess;
	/** 하위 Cls수*/
	private int subClsCnt;
	/** 게시판 리소스 수*/
	private int subResCnt;
	/** 게시판 접근 권한*/
	private int accessLvl;
	
	/** 연결URL*/
	private String carUrl;
	/** 자원 설명*/
	private String carExplain;
	public int getCarID() {
		return carID;
	}
	public void setCarID(int carID) {
		this.carID = carID;
	}
	public String getCarName() {
		return carName;
	}
	public void setCarName(String carName) {
		this.carName = carName;
	}
	public String getCarName2() {
		return carName2;
	}
	public void setCarName2(String carName2) {
		this.carName2 = carName2;
	}
	public int getCarLevel() {
		return carLevel;
	}
	public void setCarLevel(int carLevel) {
		this.carLevel = carLevel;
	}
	public int getCarStep() {
		return carStep;
	}
	public void setCarStep(int carStep) {
		this.carStep = carStep;
	}
	public int getCarUpper() {
		return carUpper;
	}
	public void setCarUpper(int carUpper) {
		this.carUpper = carUpper;
	}
	public String getCarGb() {
		return carGb;
	}
	public void setCarGb(String carGb) {
		this.carGb = carGb;
	}
	public String getCarAccess() {
		return carAccess;
	}
	public void setCarAccess(String carAccess) {
		this.carAccess = carAccess;
	}
	public int getSubClsCnt() {
		return subClsCnt;
	}
	public void setSubClsCnt(int subClsCnt) {
		this.subClsCnt = subClsCnt;
	}
	public int getSubResCnt() {
		return subResCnt;
	}
	public void setSubResCnt(int subResCnt) {
		this.subResCnt = subResCnt;
	}
	public int getAccessLvl() {
		return accessLvl;
	}
	public void setAccessLvl(int accessLvl) {
		this.accessLvl = accessLvl;
	}
	public String getCarUrl() {
		return carUrl;
	}
	public void setCarUrl(String carUrl) {
		this.carUrl = carUrl;
	}
	public String getCarExplain() {
		return carExplain;
	}
	public void setCarExplain(String carExplain) {
		this.carExplain = carExplain;
	}

	

	
}
