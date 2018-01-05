var dropzone = document.getElementById("dropzone"); // id of drag/drop zone
var listing = document.getElementById("listing");   // id of table to show the result

function scanFiles(item, container) {
  let elem = document.createElement("li");
  elem.innerHTML = item.name;
  container.appendChild(elem);
 
 if (item.isDirectory) {
    let directoryReader = item.createReader();
    let directoryContainer = document.createElement("ul");
    container.appendChild(directoryContainer);
    
    directoryReader.readEntries(function(entries) {
        entries.forEach(function(entry) {
          scanFiles(entry, directoryContainer);
      });
    });
  }
}

dropzone.addEventListener("dragover", function(event) {
    event.preventDefault();
}, false);

dropzone.addEventListener("drop", function(event) {
  var items = event.dataTransfer.items;

  event.preventDefault();
  listing.innerHTML = "";
 
  for (var i = 0; i < items.length; i++) {
    var item = items[i].webkitGetAsEntry();
    
    if (item) {
        scanFiles(item, listing);
    }
  }
}, false);