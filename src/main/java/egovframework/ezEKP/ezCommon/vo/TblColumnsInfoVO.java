package egovframework.ezEKP.ezCommon.vo;

public class TblColumnsInfoVO {
	/** 컬럼명*/
	private String columnNm;
	/** 컬럼 default값*/
	private String columnDefault;
	/** null 허용 여부*/
	private String isNullAble;
	/** 컬럼 타입*/
	private String columnType;
	
	public String getColumnNm() {
		return columnNm;
	}
	public void setColumnNm(String columnNm) {
		this.columnNm = columnNm;
	}
	public String getColumnDefault() {
		return columnDefault;
	}
	public void setColumnDefault(String columnDefault) {
		this.columnDefault = columnDefault;
	}
	public String getIsNullAble() {
		return isNullAble;
	}
	public void setIsNullAble(String isNullAble) {
		this.isNullAble = isNullAble;
	}
	public String getColumnType() {
		return columnType;
	}
	public void setColumnType(String columnType) {
		this.columnType = columnType;
	}
	

}
