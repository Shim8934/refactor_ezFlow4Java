/**
 * @file 모듈에 관계없이 첨부파일 관련 유용한 툴을 제공합니다.
 * @author 솔루션1팀 김은실
 * @version 1.0.0
 * @date 2025-02-18
 */

/**
 * 서버에 요청해서 가져다가 dataTransfer에 담아주는 util.
 *
 * @param {Array} requestUrls 서버에 요청 보낼 url 배열.
 *
 * - 블록 레벨 스코프 : 모든 코드 블록(if, for, while, try/catch 등)
 * 		- const : 선언 동시 초기화 | 재선언 X, 재할당 X (객체는 값 변경 가능)
 * 		- let : 재선언 X, 재할당 O
 * - fetch: "fetch는 비동기 HTTP 요청을 처리하는 강력한 도구입니다." -ChatGPT
 */
async function getDataTransfer(requestUrls) {
    const dataTransfer = new DataTransfer(); // 파일 크기 제한은 브라우저에 따라 다르지만 보통 약 4GB 정도입니다. eml 최대크기는 64MB

    for (const url of requestUrls) {
        try {
            const response = await fetch(url);

            // fileName
            // Content-Disposition 헤더에서 filename 추출
            const contentDisposition = response.headers.get("Content-Disposition");
            let fileName = "downloaded_file";

            if (contentDisposition) {
                const match = contentDisposition.match(/filename\*?=(?:UTF-8'')?["']?([^"';]+)["']?/i);
                if (match) {
                    fileName = decodeURIComponent(match[1]);

                    // 파일명은 attachFileNameMaxLength 자를 넘을 수 없습니다.
                    if (attachFileNameMaxLength && attachFileNameMaxLength < fileName.length) {
                        // alert을 띄워야 할까?
                        const extension = fileName.substring(fileName.lastIndexOf(".")); // .eml
                        fileName = fileName.substring(0, attachFileNameMaxLength - extension.length) + extension; // fileName(0, 100-4) + .eml
                    }
                }
            }

            // 파일 데이터를 가져와서 Blob → File 변환
            const blob = await response.blob();
            const file = new File([blob], fileName, { type: response.headers.get("Content-Type") });
            dataTransfer.items.add(file);

            console.debug("파일이 <input type='file'>에 설정되었습니다:", file.name);
        } catch (error) {
            console.error("파일 설정 중 오류 발생:", error);
        }
    }

    return dataTransfer;
}
