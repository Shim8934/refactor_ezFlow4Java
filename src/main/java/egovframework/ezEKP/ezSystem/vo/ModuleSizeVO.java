package egovframework.ezEKP.ezSystem.vo;

import java.util.HashMap;
import java.util.Map;

public class ModuleSizeVO {
	private long storageSize;
	private long tableSize;
	private long totalSizePerModule;
	
	private String storageSizeStr;
	private String tableSizeStr;
	private String totalSizePerModuleStr;
	
	private Map<String, ModuleSizeVO> moduleMap;
	
	public ModuleSizeVO() {
		this(false);
	}
	public ModuleSizeVO(boolean moduleMapFlag) {
		if(moduleMapFlag) {
			this.moduleMap = new HashMap<String, ModuleSizeVO>();
		}
	}
	
	public long getStorageSize() {
		return storageSize;
	}
	public void setStorageSize(long storageSize) {
		this.storageSize = storageSize;
	}
	public long getTableSize() {
		return tableSize;
	}
	public void setTableSize(long tableSize) {
		this.tableSize = tableSize;
	}
	public long getTotalSizePerModule() {
		return totalSizePerModule;
	}
	public void setTotalSizePerModule(long totalSizePerModule) {
		this.totalSizePerModule = totalSizePerModule;
	}
	public Map<String, ModuleSizeVO> getModuleMap() {
		return moduleMap;
	}
	public void setModuleMap(Map<String, ModuleSizeVO> moduleMap) {
		this.moduleMap = moduleMap;
	}
	public String getStorageSizeStr() {
		return storageSizeStr;
	}
	public void setStorageSizeStr(String storageSizeStr) {
		this.storageSizeStr = storageSizeStr;
	}
	public String getTableSizeStr() {
		return tableSizeStr;
	}
	public void setTableSizeStr(String tableSizeStr) {
		this.tableSizeStr = tableSizeStr;
	}
	public String getTotalSizePerModuleStr() {
		return totalSizePerModuleStr;
	}
	public void setTotalSizePerModuleStr(String totalSizePerModuleStr) {
		this.totalSizePerModuleStr = totalSizePerModuleStr;
	}
	
	/**custom method*/
	public void putModuleMap(String name, ModuleSizeVO moduleVo) {
		this.moduleMap.put(name, moduleVo);
	}
}
