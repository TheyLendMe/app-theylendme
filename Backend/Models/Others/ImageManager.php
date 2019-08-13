<?php class ImageManager{

  public function ImageManager($path, $root_dir){
    $this->public_path_to_dir = $path;
    $this->dir = $root_dir;
  }

  private function getUserDir($idUser){
    return md5($idUser);
  }
  private function getGroupDir($idGroup, $creationDate){
    $groupKey = "Group-$idGroup-$creationDate";
    return md5($groupKey);
  }

  public function getUserPath($idUser){
    return (
      $this->public_path_to_dir."/".
      $this->dir."/".
      $this->getUserDir($idUser)."/"
    );
  }

  public function getGroupPath($idGroup, $creationDate){
    return (
      $this->public_path_to_dir."/".
      $this->dir."/".
      $this->getGroupDir($idGroup, $creationDate)."/"
    );
  }

  public function createUserDir($idUser){
    $success = false;
    $dir = $this->dir."/".$this->getUserDir($idUser);
    if (!is_dir($dir)) {
      mkdir($dir, 0701);
      $success = true;
    }
    return $success;
  }

  public function createGroupDir($idGroup, $creationDate){
    $success = false;
    $dir = $this->dir."/".$this->getGroupDir($idGroup, $creationDate);
    if (!is_dir($dir)) {
      mkdir($dir, 0701);
      $success = true;
    }
    return $success;
  }

  public function saveImageUser($idUser){
    $file_tmp = $_FILES['image']['tmp_name'];
    $file_ext = strtolower(end(explode('.',$_FILES['image']['name'])));

    //Creamos el directorio si no existe
    $dir_path = $this->dir."/".$this->getUserDir($idUser);
    if (!is_dir($dir_path)) {
      $created = $this->createUserDir($idUser);
      if ($created === false) ResponseManager::returnErrorResponse('directory');
    }

    //Asign imagename base on the num of files in dir
    $fi = new FilesystemIterator(
      $dir_path,
      FilesystemIterator::SKIP_DOTS
    );
    $count = iterator_count($fi) + 1;
    $file_name = $count.".".$file_ext;
    $tmp_file_name = "_".$file_name;

    //Save the image
    while(file_exists($file_name)){
      $file_name = rand(0, 100).$file_name;
      $tmp_file_name = "_".$file_name;
    }

    // $success = move_uploaded_file($file_tmp, $dir_path."/".$file_name);
    $success = move_uploaded_file($file_tmp, $dir_path."/".$tmp_file_name);
    if ($success === false) ResponseManager::returnErrorResponse('imageSaving');

    //Resize image
    $this->resizeImage(
      $dir_path."/".$tmp_file_name,
      $dir_path."/".$file_name
    );

    //Return image path
    return ($this->getUserPath($idUser).$file_name);
  }

  public function saveImageGroup($idGroup, $creationDate){
    $file_tmp = $_FILES['image']['tmp_name'];
    $file_ext = strtolower(end(explode('.',$_FILES['image']['name'])));

    //Creamos el directorio si no existe
    $dir_path = $this->dir."/".$this->getGroupDir($idGroup, $creationDate);
    if (!is_dir($dir_path)) {
      $created = $this->createGroupDir($idGroup, $creationDate);
      if ($created === false) ResponseManager::returnErrorResponse('directory');
    }

    //Asign imagename base on the num of files in dir
    $fi = new FilesystemIterator(
      $dir_path,
      FilesystemIterator::SKIP_DOTS
    );
    $count = iterator_count($fi) + 1;
    $file_name = $count.".".$file_ext;
    $tmp_file_name = "_".$file_name;

    //Save the image
    while(file_exists($file_name)){
      $file_name = rand(0, 100).$file_name;
      $tmp_file_name = "_".$file_name;
    }

    $success = move_uploaded_file($file_tmp, $dir_path."/".$tmp_file_name);
    if ($success === false) ResponseManager::returnErrorResponse('imageSaving');

    //Resize image
    $this->resizeImage(
      $dir_path."/".$tmp_file_name,
      $dir_path."/".$file_name
    );

    //Return image path
    return ($this->getGroupPath($idGroup, $creationDate).$file_name);
  }


  private function resizeImage($tpmName, $finalName, $ancho = 800){
    // Obtener las dimensiones orginales
    list($ancho_orig, $alto_orig) = getimagesize($tpmName);
    $ratio_orig = $ancho_orig/$alto_orig;

    //Calculamos las nuevas dimensiones (ancho como parametro)
    $alto = $ancho / $ratio_orig;

    //Copiamos la imagen para redimensionarla
    $ext = strtolower(end(explode('.', $tpmName)));
    switch ($ext) {
  	  case "jpg":
  		case "jpeg":
        $imagen_src = imagecreatefromjpeg($tpmName);
        $imagen_dst = imagecreatetruecolor($ancho, $alto);
        imagecopyresampled($imagen_dst, $imagen_src, 0, 0, 0, 0, $ancho, $alto, $ancho_orig, $alto_orig);
        imagejpeg($imagen_dst, $finalName);
        break;
      case "png":
        $imagen_src = imagecreatefrompng($tpmName);
        $imagen_dst = imagecreatetruecolor($ancho, $alto);
        imagecopyresampled($imagen_dst, $imagen_src, 0, 0, 0, 0, $ancho, $alto, $ancho_orig, $alto_orig);
        imagepng($imagen_dst, $finalName);
        break;
      default: break;
    }

    //Borramos la imagen original
    system("rm $tpmName");
  }

} ?>
