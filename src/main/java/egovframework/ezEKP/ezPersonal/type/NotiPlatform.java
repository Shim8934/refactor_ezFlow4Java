package egovframework.ezEKP.ezPersonal.type;

public enum NotiPlatform {

	MAIL(1),
	PC_TALK(2),
	MOBILE_WEBAPP(3),
	TOTAL_NOTI(4);

	private final int intValue;

	NotiPlatform(int intValue) {
		this.intValue = intValue;
	}

	public int intValue() {
		return intValue;
	}

	public static NotiPlatform valueOf(int intValue) {
		for (NotiPlatform platform : values()) {
			if (intValue == platform.intValue) {
				return platform;
			}
		}

		return null;
	}

}
