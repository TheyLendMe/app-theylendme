<?php class Users {

  //Class contructor
  public function Users($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'Users';
    $this->inmutableFields = ['idUser', 'signUpDate'];
    $this->mutableFields = ['nickname', 'email', 'tfno', 'info', 'imagen'];
  }

  //Creates a new user, mutable fields optional.
  function createUser($idUser, $nickname = null, $email = null, $tfno = null, $info = null){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idUser, nickname, email, tfno, info, signUpDate)
      values (?, ?, ?, ?, ?, now() );");
    $sth->execute( array($idUser, $nickname, $email, $tfno, $info) );
    $ins = $sth->rowCount();
    return ($ins === 0 ? false : true);
  }

  //VOID METHODS ***************************************************************
  //Update the mutable fields of the user
  function updateUser($idUser, $fieldName, $fieldValue){
    if ($idUser == null) return false;

    $updatedFields = 0;

    for( $i = 0; $i < count($fieldName); $i++) {
      if (in_array($fieldName[$i], $this->inmutableFields)) continue;
      if (!in_array($fieldName[$i], $this->mutableFields)) continue;

      $sth = $this->pdo->prepare("Update $this->tableName set ".$fieldName[$i]." = ? where idUser = ?;");
      $sth->execute(array($fieldValue[$i], $idUser));
      $upd = $sth->rowCount();
      if ($upd != 0) $updatedFields++;
    }

    return ($updatedFields === 0) ? false : $updatedFields;
  }

  //Delete a user by its id
  function deleteUser($idUser){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));

    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  function checkUser($idUser){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));
    $exists = $sth->rowCount();
    return ($exists === 0 ? false : true);
  }
  //****************************************************************************

  //GET METHODS*****************************************************************
  //Returns a user by its id
  function getUser($idUser){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));
    //ONE ROW EXPECTED
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }

  //Return users where its name match a specific pattern
  function getUserByNickname($pattern){
    if ($pattern == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where nickname like ?;");
    $sth->execute(array("%$pattern%"));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  function getSignUpDate($idUser){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("Select signUpDate from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));
    $date = $sth->fetch(PDO::FETCH_ASSOC);
    return $date;
  }

  //Return the table fields -> NULL - all, TRUE - mutable, FALSE - inmutable
  function getFields($mutable = null){
    if ($mutable === null){
      $fields = array_merge($this->inmutableFields, $this->mutableFields);
    }elseif ($mutable === true){
      $fields = $this->mutableFields;
    }elseif ($mutable === false){
      $fields = $this->inmutableFields;
    }
    return $fields;
  }

  function getNullFields($idUser){
    if ($idUser == null) return null;

    $fields = [];
    $usr = $this->getUser($idUser);

    for ($i=0; $i < count($this->mutableFields); $i++) {
      if ( ($usr[$this->mutableFields[$i]] == null) || ($usr[$this->mutableFields[$i]] === '') ) $fields[] = $this->mutableFields[$i];
    }
    return $fields;
  }
  //****************************************************************************
} ?>
