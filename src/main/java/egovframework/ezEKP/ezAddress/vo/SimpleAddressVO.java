package egovframework.ezEKP.ezAddress.vo;

public class SimpleAddressVO {	
	private String name;
	private String email;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	@Override
	public String toString() {
		return "SimpleAddressVO [name=" + name + ", email=" + email + "]";
	}
	
	
}
