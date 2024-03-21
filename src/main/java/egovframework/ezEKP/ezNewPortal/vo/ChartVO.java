package egovframework.ezEKP.ezNewPortal.vo;


public class ChartVO {
    // not null
    private String label;
    private int val;
    // nullable
    private String color = "";
    private String borderColor = "";
    private String hoverColor = "";
    private String hoverBorderColor = "";
    /** for stack barChart*/
    private String groupTitle = "";


    public String getLabel() {
        return label;
    }

    public int getVal() {
        return val;
    }

    public String getGroupTitle() {
        return groupTitle;
    }

    public String getColor() {
        return color;
    }

    public String getBorderColor() {
        return borderColor;
    }

    public String getHoverColor() {
        return hoverColor;
    }

    public String getHoverBorderColor() {
        return hoverBorderColor;
    }

    @Override
    public String toString() {
        return "ChartVO{" +
                "label='" + label + '\'' +
                ", val=" + val +
                ", groupTitle='" + groupTitle + '\'' +
                ", color='" + color + '\'' +
                ", borderColor='" + borderColor + '\'' +
                ", hoverColor='" + hoverColor + '\'' +
                ", hoverBorderColor='" + hoverBorderColor + '\'' +
                '}';
    }

    public static final class ChartVOBuilder {
        private String label;
        private int val;
        // nullable
        private String color = "";
        private String borderColor = "";
        private String hoverColor = "";
        private String hoverBorderColor = "";
        /** for stack barChart*/
        private String groupTitle = "";

        public ChartVOBuilder(String label, int val) {
            this.label = label;
            this.val = val;
        }

        public ChartVOBuilder groupTitle(String groupTitle) {
            this.groupTitle = groupTitle;
            return this;
        }

        public ChartVOBuilder color(String color) {
            this.color = color;
            return this;
        }

        public ChartVOBuilder borderColor(String borderColor) {
            this.borderColor = borderColor;
            return this;
        }

        public ChartVOBuilder hoverColor(String hoverColor) {
            this.hoverColor = hoverColor;
            return this;
        }

        public ChartVOBuilder hoverBorderColor(String hoverBorderColor) {
            this.hoverBorderColor = hoverBorderColor;
            return this;
        }

        public ChartVO build() {
            ChartVO chartVO = new ChartVO();
            chartVO.groupTitle = this.groupTitle;
            chartVO.label = this.label;
            chartVO.val = this.val;
            chartVO.color = this.color;
            chartVO.borderColor = this.borderColor;
            chartVO.hoverColor = this.hoverColor;
            chartVO.hoverBorderColor = this.hoverBorderColor;
            return chartVO;
        }
    }
}



