package egovframework.ezMobile.ezWebfolder.vo;

import egovframework.ezMobile.ezOption.vo.MCommonVO;

public class MWebfolderFetchInfo {

	private String serverName;
	private MCommonVO user;

	private int page;
	private int size;
	private int offset;

	private String search;
	private String filter;

	public String getServerName() {
		return serverName;
	}

	public void setServerName(String serverName) {
		this.serverName = serverName;
	}

	public MCommonVO getUser() {
		return user;
	}

	public void setUser(MCommonVO user) {
		this.user = user;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

	public int getOffset() {
		return offset;
	}

	public void setOffset(int offset) {
		this.offset = offset;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public String getFilter() {
		return filter;
	}

	public void setFilter(String filter) {
		this.filter = filter;
	}

}
