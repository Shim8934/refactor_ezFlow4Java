package egovframework.ezEKP.ezPersonal.vo;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

public class PersonalNotiDisableItemVO {

	private int mainType;
	private int subType;
	private int platform;

	public int getMainType() {
		return mainType;
	}

	public void setMainType(int mainType) {
		this.mainType = mainType;
	}

	public int getSubType() {
		return subType;
	}

	public void setSubType(int subType) {
		this.subType = subType;
	}

	public int getPlatform() {
		return platform;
	}

	public void setPlatform(int platform) {
		this.platform = platform;
	}

	@Override
	public String toString() {
		return "PersonalNotiDisableItemVO [mainType=" + mainType + ", subType=" + subType + ", platform=" + platform + "]";
	}

	@Override
	public int hashCode() {
		return Objects.hash(mainType, subType, platform);
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof PersonalNotiDisableItemVO && hashCode() == obj.hashCode();
	}

	public static class Finder {

		private final List<Integer> hashesWithoutSubType;
		private final Set<Integer> hashes;

		public Finder(Collection<PersonalNotiDisableItemVO> items) {
			hashesWithoutSubType = new ArrayList<>(items.size());
			hashes = items.stream().peek(this::addHashWithoutSubType).map(Object::hashCode).collect(Collectors.toSet());
		}

		public boolean find(int mainType, int subType, int platform) {
			return hashes.contains(Objects.hash(mainType, subType, platform));
		}

		public int getCountWithoutSubType(int mainType, int platform) {
			return (int) hashesWithoutSubType.stream().filter(((Integer) Objects.hash(mainType, platform))::equals).count();
		}

		private void addHashWithoutSubType(PersonalNotiDisableItemVO item) {
			hashesWithoutSubType.add(Objects.hash(item.mainType, item.platform));
		}

	}

}
