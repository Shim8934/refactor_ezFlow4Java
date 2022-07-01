package egovframework.ezEKP.ezPersonal.vo;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;

public class PersonalNotiPreferencesVO {

	/** 0: 모두받기(기본), 1: 지정시간만 받기, 2: 받지않기 */
	private int receiveType;

	/** 0: 공유일 받기(기본), 1: 공휴일 받지않기 */
	private int notReceiveHolidayFlag;

	/**
	 * 시작 시간(지정시간만 받기 전용)<br>
	 * startTime / 100: 시, startTime % 100: 분
	 */
	private int startTime;

	/**
	 * 종료 시간(지정시간만 받기 전용)<br>
	 * endTime / 100: 시, endTime % 100: 분
	 */
	private int endTime;

	public static PersonalNotiPreferencesVO byConfigValue(String notiPreferencesConfigValue) {
		PersonalNotiPreferencesVO result = new PersonalNotiPreferencesVO();

		if (StringUtils.isBlank(notiPreferencesConfigValue)) {
			return result;
		}

		String[] args = notiPreferencesConfigValue.split(":", 4);

		if (args.length == 4) {
			result.receiveType = NumberUtils.toInt(args[0]);
			result.notReceiveHolidayFlag = NumberUtils.toInt(args[1]);

			if (result.isFixedTimeReceive()) {
				result.startTime = NumberUtils.toInt(args[2]);
				result.endTime = NumberUtils.toInt(args[3]);
			}
		}

		return result;
	}

	public int getReceiveType() {
		return receiveType;
	}

	public void setReceiveType(int receiveType) {
		this.receiveType = receiveType;
	}

	public int getNotReceiveHolidayFlag() {
		return notReceiveHolidayFlag;
	}

	public void setNotReceiveHolidayFlag(int notReceiveHolidayFlag) {
		this.notReceiveHolidayFlag = notReceiveHolidayFlag;
	}

	public int getStartTime() {
		return startTime;
	}

	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}

	public int getEndTime() {
		return endTime;
	}

	public void setEndTime(int endTime) {
		this.endTime = endTime;
	}

	public boolean isAlwaysReceive() {
		return receiveType == 0;
	}

	public boolean isFixedTimeReceive() {
		return receiveType == 1;
	}

	public boolean isNotReceive() {
		return receiveType == 2;
	}

	public boolean canReceiveHoliday() {
		return notReceiveHolidayFlag == 0;
	}

	@Override
	public String toString() {
		return "PersonalNotiPreferencesVO [receiveType=" + receiveType + ", notReceiveHolidayFlag=" + notReceiveHolidayFlag + ", startTime=" + startTime + ", endTime=" + endTime + "]";
	}

	public String toConfigValue() {
		if (isFixedTimeReceive()) {
			return receiveType + ":" + notReceiveHolidayFlag + ":" + startTime + ":" + endTime;
		}

		return receiveType + ":" + notReceiveHolidayFlag + "::";
	}
}
