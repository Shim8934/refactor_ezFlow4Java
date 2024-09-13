package egovframework.ezEKP.ezApprovalG.type;

public class PortletAprListType {

    public int getAprIngEndType(int intValue) {
        if (intValue == AprListType.APPR.intValue() || intValue == AprListType.APPR_PROGRESSING.intValue() || intValue == AprListType.APPR_GONGRAM.intValue() ){
            return AprIngEndType.ING.intValue();
        } else {
            return AprIngEndType.END.intValue();
        }
    }

    public enum AprListType {
        APPR(1),
        APPR_END(2),
        APPR_PROGRESSING(3),
    	APPR_GONGRAM(99);

        private final int intValue;

        AprListType(int intValue) {
            this.intValue = intValue;
        }

        public int intValue() {
            return intValue;
        }

        public static AprListType valueOf(int intValue) {
            for (AprListType aprType : values()) {
                if (intValue == aprType.intValue) {
                    return aprType;
                }
            }

            return null;
        }
    }

    public enum AprIngEndType{
        ING(1),
        END(2);
        private final int intValue;

        AprIngEndType(int intValue) {
            this.intValue = intValue;
        }

        public int intValue() {
            return intValue;
        }
    }

}