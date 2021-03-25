package egovframework.ezEKP.ezCabinet.vo;

import java.util.List;

public class CabinetSimpleVO {
	private int    cabinetId;
	private String cabinetName;
	private String cabinetName1;
	private String cabinetName2;
	private String cabinetPath;
	private int    parentId;
	private int    cabinetLevel;
	private int    cabinetStep;
	private int    hasSub;
	private List<CabinetSimpleVO> subList;
	
	public CabinetSimpleVO() {}
	
	public CabinetSimpleVO(int cabinetId, String cabinetName, String cabinetName1, String cabinetName2, int hasSub, int cabinetLevel, int cabinetStep, List<CabinetSimpleVO> list) {
		this.cabinetId    = cabinetId;
		this.cabinetName  = cabinetName;
		this.cabinetName1 = cabinetName1;
		this.cabinetName2 = cabinetName2;
		this.cabinetLevel = cabinetLevel;
		this.cabinetStep  = cabinetStep;
		this.hasSub       = hasSub;
		this.subList      = list;
	}
	
	public int getCabinetId() {
		return cabinetId;
	}
	
	public void setCabinetId(int cabinetId) {
		this.cabinetId = cabinetId;
	}
	
	public String getCabinetName() {
		return cabinetName;
	}
	
	public void setCabinetName(String cabinetName) {
		this.cabinetName = cabinetName;
	}
	
	public int getCabinetLevel() {
		return cabinetLevel;
	}
	
	public void setCabinetLevel(int cabinetLevel) {
		this.cabinetLevel = cabinetLevel;
	}
	
	public int getCabinetStep() {
		return cabinetStep;
	}
	
	public void setCabinetStep(int cabinetStep) {
		this.cabinetStep = cabinetStep;
	}
	
	public int getHasSub() {
		return hasSub;
	}
	
	public void setHasSub(int hasSub) {
		this.hasSub = hasSub;
	}
	
	public List<CabinetSimpleVO> getSubList() {
		return subList;
	}
	
	public void setSubList(List<CabinetSimpleVO> subList) {
		this.subList = subList;
	}
	
	public int getParentId() {
		return parentId;
	}
	
	public void setParentId(int parentId) {
		this.parentId = parentId;
	}
	
	public String getCabinetName1() {
		return cabinetName1;
	}
	
	public void setCabinetName1(String cabinetName1) {
		this.cabinetName1 = cabinetName1;
	}
	
	public String getCabinetName2() {
		return cabinetName2;
	}
	
	public void setCabinetName2(String cabinetName2) {
		this.cabinetName2 = cabinetName2;
	}
	
	public String getCabinetPath() {
		return cabinetPath;
	}
	
	public void setCabinetPath(String cabinetPath) {
		this.cabinetPath = cabinetPath;
	}
}
