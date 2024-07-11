package egovframework.ezEKP.ezBoard.type;

/**
 * 게시판 구분
 * @see #GENERAL
 * @see #ANONYMOUS
 * @see #PHOTO
 * @see #THUMBNAIL
 * @see #QNA
 * @see #MOVIE
 */
public enum BoardGubun {
    /**
     * 일반 게시판
     */
    GENERAL(0),
    /**
     * 익명 게시판
     */
    ANONYMOUS(2),
    /**
     * 사진 게시판
     */
    PHOTO(3),
    /**
     * 썸네일 게시판
     */
    THUMBNAIL(4),
    /**
     * Q&A 게시판
     */
    QNA(5),
    /**
     * 영상 게시판
     */
    MOVIE(7);

    private final int code;

    BoardGubun(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    public static BoardGubun valueOf(int code) {
        for (BoardGubun boardGubun : values()) {
            if (boardGubun.code == code) {
                return boardGubun;
            }
        }
        throw new IllegalArgumentException("No matching constant for [" + code + "]");
    }
}
