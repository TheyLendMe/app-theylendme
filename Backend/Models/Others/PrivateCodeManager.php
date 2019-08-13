<?php class PrivateCodeManager{

  public static function getPrivateCode($id, $foundDate){
    $date = explode(' ', date('Y m d H i s'));

    $passphase = $date[2].$date[0].$foundDate.$date[1].$id.$date[3];
    $sha = hash('sha256', $passphase);
    $md5 = md5(md5($sha));

    return $md5;
  }

  public static function checkPrivateCode($code, $id, $foundDate){
    $date = explode(' ', date('Y m d H i s'));

    $passphase = $date[2].$date[0].$foundDate.$date[1].$id.$date[3];
    $sha = hash('sha256', $passphase);
    $md5 = md5(md5($sha));

    return ( ($code === $md5 ) ? true : false);
  }

} ?>
