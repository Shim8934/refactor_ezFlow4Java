
function extractEmailContent() {
  const normalScreen = document.getElementById('normalScreen');
  if (normalScreen) {
    const htmlString = normalScreen.outerHTML;
    
    return removeHtmlTag(htmlString);
  } else {
    console.log(msgErrExtract);
    return "";
  }
}

function extractEmailMetaData() {
    const subModule = getSubModuleType();
    const parentDoc = window.parent.document;
    
    if ('preview' == subModule) {
        // 제목
        const subjectEl = parentDoc.querySelector('#PreH_sub_subject');
        const subject = subjectEl ? subjectEl.innerText.trim() : '';

        // From (보낸사람)
        const senderNameEl = parentDoc.querySelector('#PreH_sub_MailSender span');
        const senderName = senderNameEl ? senderNameEl.innerText.trim() : '';
        const senderEmail = senderNameEl ? senderNameEl.getAttribute('title') || '' : '';
        const sender = senderName && senderEmail ? `${senderName}<${senderEmail}>` : senderName || senderEmail;

        // To (받는사람)
        const receiverEl = parentDoc.querySelector('#PreH_MailReceiver span');
        const receiverName = receiverEl ? receiverEl.innerText.trim() : '';
        const receiverEmail = receiverEl ? receiverEl.getAttribute('title') || '' : '';
        const recipient = receiverName && receiverEmail ? `${receiverName}<${receiverEmail}>` : receiverName || receiverEmail;

        let cc = [];
        
        // 기본 CC 영역 (있는 경우)
        const ccInline = parentDoc.querySelector('#PreH_MailCC');
        if (ccInline) {
            const ccSpans = ccInline.querySelectorAll('span[title]');
            ccSpans.forEach(span => {
                const name = span.innerText.trim();
                const email = span.getAttribute('title') || '';
                const entry = name && email ? `${name}<${email}>` : name || email;
                if (entry && !cc.includes(entry)) {
                    cc.push(entry);
                }
            });
        }
        
        // 숨겨진 CC 상세 영역
        const ccLayer = parentDoc.querySelector('#PreH_MailCC_Rayer');
        if (ccLayer) {
            const ccSpans = ccLayer.querySelectorAll('span[title]');
            ccSpans.forEach(span => {
                const name = span.innerText.trim();
                const email = span.getAttribute('title') || '';
                const entry = name && email ? `${name}<${email}>` : name || email;
                if (entry && !cc.includes(entry)) {
                    cc.push(entry);
                }
            });
        }

        const tagEl = parentDoc.querySelector('#pre_h_tag_view .tag_name');
        const tagName = tagEl ? tagEl.innerText.trim() : '';

        const dateEl = parentDoc.querySelector('#PreH_date');
        const date = dateEl ? dateEl.innerText.trim() : '';

        console.log(subject + "," + sender + "," + recipient + "," + JSON.stringify(cc) + "," + date + "," + tagName);

        return {
            'subject': subject,
            'from': sender,
            'to': recipient,
            'cc': cc,
            'date': date,
            'tag_name': tagName
        };
    } else if ('read' == subModule) {
        // 제목
        const subjectEl = parentDoc.querySelector('#LabelSubject');
        const subject = subjectEl ? subjectEl.innerText : '';
    
        // From (보낸사람)
        const senderNameEl = parentDoc.querySelector('#LabelFromName');
        const senderName = senderNameEl ? senderNameEl.innerText : '';
        const senderEl = parentDoc.querySelector('#MsgToPut');
        const senderEmail = senderEl ? senderEl.getAttribute('title') || '' : '';
        const sender = senderName && senderEmail ? `${senderName}<${senderEmail}>` : senderName || senderEmail;
        
        // To (받는사람)
        const recipientEl = parentDoc.querySelector('#LabelTo span:first-child');
        const recipientName = recipientEl ? recipientEl.innerText : '';
        const recipientEmail = recipientEl ? recipientEl.getAttribute('title') || '' : '';
        const recipient = recipientName && recipientEmail ? `${recipientName}<${recipientEmail}>` : recipientName || recipientEmail;
      
        // CC (참조)
        let cc = [];
        
        // CC 기본 표시 영역
        const ccContainer = parentDoc.querySelector('#LabelCC');
        if (ccContainer) {
            const ccSpans = ccContainer.querySelectorAll('span[title]');
            ccSpans.forEach(span => {
                const name = span.innerText;
                const email = span.getAttribute('title') || '';
                if (name || email) {
                    cc.push(name && email ? `${name}<${email}>` : name || email);
                }
            });
        }
        
        // 숨겨진 CC 영역 (여러 명일 경우)
        const hiddenCcContainer = parentDoc.querySelector('#LabelCCHidden');
        if (hiddenCcContainer) {
            const hiddenCcSpans = hiddenCcContainer.querySelectorAll('span[title]');
            hiddenCcSpans.forEach(span => {
                const name = span.innerText;
                const email = span.getAttribute('title') || '';
                if (name || email) {
                    // 중복 방지를 위한 검사
                    const entry = name && email ? `${name}<${email}>` : name || email;
                    if (!cc.includes(entry)) {
                        cc.push(entry);
                    }
                }
            });
        }
        
        // 태그
        const tagNameEl = parentDoc.querySelector('#tag_name');
        const tagName = tagNameEl ? tagNameEl.innerText : '';
        
        // 날짜
        const dateEl = parentDoc.querySelector('#LabelReceiveDate');
        const date = dateEl ? dateEl.innerText : '';
        
        console.log(subject + "," + sender + "," + recipient + "," + JSON.stringify(cc) + "," + date + "," + tagName);
        
        return {
            'subject': subject,
            'from': sender,
            'to': recipient,
            'cc': cc,
            'date': date,
            'tag_name': tagName
        };
    }
    
    return;
}



