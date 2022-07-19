var path = window. location. pathname;
var page = path. split("/"). pop();
console. log( page );

if (page === 'verified-commercial-hardware.html') {

  // Menu
  document.getElementById('block-headersolutions').style.display = 'none';
  // Graphic
  document.querySelector('.content hero').style.display = 'none';
  // Hardware ready program block
  document.querySelector('.content section padding-30 no-pdb').style.display = 'none';
  // Footer
  document.querySelector('.content footer').style.display = 'none';
  // Cookie policy
  document.getElementById('teconsent').style.display = 'none';

  // Strings
  document.body.innerHTML = document.body.innerHTML.replace(/Studio Cloud Version/g, 'StarlingX Version');
  document.body.innerHTML = document.body.innerHTML.replace(/21.05/g, '5.0');
  document.body.innerHTML = document.body.innerHTML.replace(/21.12/g, '6.0');
  document.body.innerHTML = document.body.innerHTML.replace(/22.06/g, '7.0');
  document.body.innerHTML = document.body.innerHTML.replace(/WRCP 22.06/g, 'StarlingX 7.0');
  document.body.innerHTML = document.body.innerHTML.replace(/WRCP 21.12/g, 'StarlingX 6.0');
  document.body.innerHTML = document.body.innerHTML.replace(/WRCP 21.05/g, 'StarlingX 5.0');
  document.body.innerHTML = document.body.innerHTML.replace(/Patch \d+/g, '');

}
