class RowSelector {
    /**
     * @param {Element} rowWrapperElement
     * @param {string} rowSelector
     * @param {string} rowInputSelector
     * @param {string} selectedClassName
     * @param {string} unselectedClassName
     */
    constructor(rowWrapperElement, rowSelector, rowInputSelector, selectedClassName, unselectedClassName) {
        this.rowWrapElement = rowWrapperElement;
        this.rowSelector = rowSelector;
        this.rowInputSelector = rowInputSelector;
        this.selectedClassName = selectedClassName;
        this.unselectedClassName = unselectedClassName;
        this.selectedClassNameRegExp = new RegExp("\\b" + selectedClassName + "\\b");
    }

    /*className = {
        selected: "bnkWebFolder2",
        unselected: "bnkWebFolder"
    };*/

    // selectedClassNameRegExp = new RegExp("\\b" + selectedClassName + "\\b");

    firstSelected = true;
    isSingleMode = false;

    onRowClick(event, rowElement) {
        event.stopPropagation();
        var element = event.target;
        // var parentElement = element.parentElement.parentElement;

        if (this.isSingleMode) {
            this.clearFocus();
            this.setSelectState(rowElement, !isSelected(rowElement));
            return;
        }

        if (this.isFirstSelected()) {
            this.firstSelected = rowElement;
            this.setSelectState(rowElement, true);
            return;
        }

        if (event.shiftKey) {
            var rows = Array.prototype.slice.call(rowWrapElement.children);
            var startIndex = rows.indexOf(firstSelected);
            var endIndex = rows.indexOf(rowElement);
            var temp;

            if (startIndex > endIndex) {
                temp = startIndex;
                startIndex = endIndex;
                endIndex = temp;
            }

            this.clearFocus();
            for (var i = startIndex; i <= endIndex; i++) {
                this.setSelectState(rows[i], true);
            }

            return;
        }

        const selectedLength = this.getSelectedRows().length;
        const isDuplicateFocus = (selectedLength === 1 && this.firstSelected === rowElement);
        /*if (folderType =="S") {
            var selectedRows = rowContext.getSelectedRows();
            var rowInfo = rowContext.getRowInfo(selectedRows[0]);

            folderType = rowInfo.targetFunction;
        }*/

        if (event.ctrlKey || isDuplicateFocus) {
            this.setSelectState(rowElement, !this.isSelected(rowElement));
        } else {
            this.clearFocus();
            this.setSelectState(rowElement, true);
            this.firstSelected = rowElement;
        }
    }

    /*selectedFileList(rowElement) {
        var selectedFile = folderId + "/" + rowElement.getAttribute("targetId");
        var selectedFileId = rowElement.getAttribute("targetId");

        var seletedCheck = folderId + "/" + rowElement.firstChild.firstChild.getAttribute("value");
        var selectedCheckId = rowElement.firstChild.firstChild.getAttribute("value");
        if (!rowElement.firstChild.firstChild.checked){
            var index = filePickArr.indexOf(selectedFile);
            var index2 = selectedCheckId.indexOf(selectedFileId);
            if (index != -1){
                filePickArr.splice(index,1);
                selectFileList.splice(index, 1);
            }
        } else {
            if (!(filePickArr.indexOf(selectedFile) > -1)){
                filePickArr.push(selectedFile);
                if (typeof selectFileList != "undefinded"){
                    selectFileList.push(selectedFileId);
                }
            }
        }
    }*/

    onCheckboxChange(event) {
        event.stopPropagation();

        var element = event.target;
        var rowElement = element.parentElement.parentElement;

        if (this.isSingleMode) {
            this.clearFocus();
            this.setSelectState(rowElement, element.checked);
            return;
        }

        if (this.isFirstSelected()) {
            this.firstSelected = rowElement;
        }

        this.setSelectState(rowElement, element.checked);
    }

    isFirstSelected() {
        return (this.firstSelected === undefined || this.getSelectedRows().length === 0);
    }

    getSelectedRows() {
        const rows = this.rowWrapElement.querySelectorAll("tr." + this.selectedClassName);

        /*if (window.contextClickedTr && rows.length <= 1) {
            return [contextClickedTr];
        }*/

        return rows;
    }

    getUnselectedRows() {
        return this.rowWrapElement.querySelectorAll(this.unselectedClassName);
    }

    /*getRowElement(targetId) {
        return document.querySelector("#tblFileList tr[targetid='"+ targetId +"'");
    }*/

    /*getRowInfo(rowElement) {
        var targetId = rowElement.getAttribute("targetId");
        var targetType = rowElement.getAttribute("targetType");
        var isFavorite = rowElement.hasAttribute("favorite");
        var creator = rowElement.getAttribute("targetCreater");
        var targetType2 = rowElement.getAttribute("targetFunction");
        var targetPath = rowElement.getAttribute("targetPath");

        return {
            id: targetId,
            type: targetType,
            isFavorite: isFavorite,
            creator : creator,
            targetFunction : targetType2,
            targetPath :targetPath
        }
    }*/

    isSelected(rowElement) {
        return rowElement.className.search(this.selectedClassNameRegExp) >= 0;
    }

    clearFocus() {
        const selectedRows = this.getSelectedRows();
        const length = selectedRows.length;

        for (let i = 0; i < length; i++) {
            this.setSelectState(selectedRows[i], false);
        }
    }

    setSelectState(rowElement, isSelect) {
        const checkboxElement = rowElement.firstChild.firstChild;
        checkboxElement.checked = isSelect;
        rowElement.setAttribute("class", isSelect ? this.selectedClassName : this.unselectedClassName);

        /*if (isSingleMode && isSelect) {
            var selectedFileId = rowElement.getAttribute("targetId");
            var selectedFile = folderId + "/" + selectedFileId;
            if (rowElement.firstChild.firstChild.checked) {
                if (typeof selectFileList != "undefinded") {
                    selectFileList.push(selectedFileId);
                }
                filePickArr.push(selectedFile);
            }
        }*/
    }

    /** @param {boolean} isEnable */
    selectAll(isEnable) {
        const targetRows = isEnable ? this.getUnselectedRows() : this.getSelectedRows();

        for (const row of targetRows) {
            this.setSelectState(row, isEnable);
        }
    }

    setSingleMode() {
        this.isSingleMode = true;
    }

    /*return {
        onRowClick: onRowClick,
        onCheckboxChange: onCheckboxChange,
        getSelectedRows: getSelectedRows,
        getUnselectedRows: getSelectedRows,
        getRowElement: getRowElement,
        getRowInfo: getRowInfo,
        setSelectState: setSelectState,
        clearFocus: clearFocus,
        selectAll: selectAll,
        setSingleMode: setSingleMode
    };*/
}