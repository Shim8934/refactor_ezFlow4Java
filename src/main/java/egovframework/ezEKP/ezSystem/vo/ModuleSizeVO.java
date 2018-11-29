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
	private long storageSizeAllModule;
	private long tableSizeAllModule;
	private long totalSizeAllModule;
	
	private String storageSizeAllModuleStr;
	private String tableSizeAllModuleStr;
	private String totalSizeAllModuleStr;
	
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
	public long getTotalSizeAllModule() {
		return totalSizeAllModule;
	}
	public void setTotalSizeAllModule(long totalSizeAllModule) {
		this.totalSizeAllModule = totalSizeAllModule;
	}
	public long getStorageSizeAllModule() {
		return storageSizeAllModule;
	}
	public void setStorageSizeAllModule(long storageSizeAllModule) {
		this.storageSizeAllModule = storageSizeAllModule;
	}
	public long getTableSizeAllModule() {
		return tableSizeAllModule;
	}
	public void setTableSizeAllModule(long tableSizeAllModule) {
		this.tableSizeAllModule = tableSizeAllModule;
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
	public String getStorageSizeAllModuleStr() {
		return storageSizeAllModuleStr;
	}
	public void setStorageSizeAllModuleStr(String storageSizeAllModuleStr) {
		this.storageSizeAllModuleStr = storageSizeAllModuleStr;
	}
	public String getTableSizeAllModuleStr() {
		return tableSizeAllModuleStr;
	}
	public void setTableSizeAllModuleStr(String tableSizeAllModuleStr) {
		this.tableSizeAllModuleStr = tableSizeAllModuleStr;
	}
	public String getTotalSizeAllModuleStr() {
		return totalSizeAllModuleStr;
	}
	public void setTotalSizeAllModuleStr(String totalSizeAllModuleStr) {
		this.totalSizeAllModuleStr = totalSizeAllModuleStr;
	}
	
	/**custom method*/
	public void putModuleMap(String name, ModuleSizeVO moduleVo) {
		this.moduleMap.put(name, moduleVo);
		
		addStorageSizeAllModule(moduleVo.getStorageSize());
		addTableSizeAllModule(moduleVo.getTableSize());
		addTotalSizeAllModule(moduleVo.getTotalSizePerModule());
	}
	public void addStorageSizeAllModule(long storageSize) {
		this.storageSizeAllModule += storageSize;
	}
	public void addTableSizeAllModule(long tableSize) {
		this.tableSizeAllModule += tableSize;
	}
	public void addTotalSizeAllModule(long totalSizePerModule) {
		this.totalSizeAllModule += totalSizePerModule;
	}
}
