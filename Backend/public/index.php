<?php
// if( count(explode('?', $_SERVER['REQUEST_URI'])) === 1) {
  include('../app/index.php');
// }else{
//   $idResource = str_replace('idResource=', '', explode('?', $_SERVER['REQUEST_URI'])[1] );
//   $name = "images/$idResource";
//   $fp = fopen($name, 'rb');
//   header("Content-Type: image/jpeg");
//   header("Content-Length: ".filesize($name));
//   fpassthru($fp);
// }
