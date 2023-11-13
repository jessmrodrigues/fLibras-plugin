class HtmlGenerator {
  String generateHtmlContent() {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <title>VLibras</title>
      </head>
      <body>
        <div vw class="enabled" style="transform: scale(2); transform-origin: top left;">
          <div vw-access-button class="active"></div>
          <div vw-plugin-wrapper>
            <div class="vw-plugin-top-wrapper"></div>
          </div>
        </div>
        <script src="https://vlibras.gov.br/app/vlibras-plugin.js"></script>
        <script>
          new window.VLibras.Widget('https://vlibras.gov.br/app');
        </script>
        <p id="texto" style="display:none"></p>
        <script>
          function setTextFromFlutter(textArray) {
            var textoElement = document.getElementById('texto');
            textoElement.innerHTML = "";

            for (var i = 0; i < textArray.length; i++) {
              var paragraph = document.createElement('p');
              paragraph.innerText = textArray[i];
              paragraph.id = i;
              textoElement.appendChild(paragraph);
            }
          }
          function fLibrasClick(id) {
            var t = document.getElementById(id);
            t.click();
          }
        </script>
      </body>
      </html>
    ''';
  }
}
