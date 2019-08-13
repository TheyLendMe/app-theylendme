<?php class UsersObjects {

  //Class contructor
  public function UsersObjects($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'UsersObjects';
    $this->inmutableFields = ['idObject', 'idUser', 'creationDate'];
    $this->mutableFields = ['imagen', 'amount', 'name', 'descr'];
  }

  //Creates an object asociated with some user. Extra info is optional
  //Returns the new idObject
  function createObject($idUser, $name = null, $imagen = null, $amount = 1, $desc = null){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("Insert into $this->tableName
      (idUser, name, imagen, amount, descr, creationDate) values (?, ?, ?, ?, ?, now() );");
    $sth->execute(array($idUser, $name, $imagen, $amount, $desc));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //Sets a given value in one given field in a given object(by its id)
  function updateObject($idObject, $fieldName, $fieldValue){
    if ($idObject == null) return false;

    $updatedFields = 0;

    for( $i = 0; $i < count($fieldName); $i++) {
      if (in_array($fieldName[$i], $this->inmutableFields)) continue;
      if (!in_array($fieldName[$i], $this->mutableFields)) continue;

      $sth = $this->pdo->prepare("Update $this->tableName set ".$fieldName[$i]." = ? where idObject = ?;");
      $sth->execute(array($fieldValue[$i], $idObject));
      $upd = $sth->rowCount();
      if ($upd != 0) $updatedFields++;
    }

    return $updatedFields;
  }

  //Delete a object by its id
  //If user is specified, delete just if the user is the owner
  function deleteObject($idObject, $idUser = null){
    if ($idObject == null) return false;

    if ($idUser == null){
      $sth = $this->pdo->prepare("Delete from $this->tableName where idObject = ?;");
      $sth->execute(array($idObject));
    }else{
      $sth = $this->pdo->prepare("Delete from $this->tableName where idObject = ? and idUser = ?;");
      $sth->execute(array($idObject, $idUser));
    }

    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //Delete all the objects owned by a user
  function deleteObjectsByUser($idUser){
    if ($idUser == null) return false;

    $sth = $this->pdo->prepare("Delete from $this->tableName where idUser = ?;");
    $sth->execute(array($idUser));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //GET METHODS*****************************************************************
  //Returns an object by its id
  function getObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idObject = ?;");
    $sth->execute(array($idObject));
    //ONE ROW EXPECTED
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }

  //Returns a list of objects by the user id (can be specified or not)
  //If not specified -> return all the objects in the DDBB
  //If second argument is false, return all the objects except the especified
  function getObjects($idUser = null, $propietary = true){
    if ($idUser == null){
      $sth = $this->pdo->prepare("Select * from $this->tableName;");
      $sth->execute();
    }else{
      if ($propietary){
        $sth = $this->pdo->prepare("Select * from $this->tableName where idUser = ?;");
      }else{
        $sth = $this->pdo->prepare("Select * from $this->tableName where idUser != ?;");
      }
      $sth->execute(array($idUser));
    }
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //get the objects i keep -> mine - Loans to other + Loans to me
  //(if someone have 2 out of 5, they will not apear here)
  function getObjectsByKeeper($idUser){
    if ($idUser == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where (
      (idUser = ? and not idObject in (select idObject from UsersLoans) )
      or
      (idObject in (select idObject from UsersLoans where idUser = ?) )
    );");
    $sth->execute(array($idUser, $idUser));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return objects where its name match a specific pattern
  function getObjectsByName($pattern){
    if ($pattern == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where name like ?;");
    $sth->execute(array("%$pattern%"));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return object which have a tag asociated which match the pattern
  function getObjectByTag($pattern){
    if ($pattern == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where idObject in
      (select idObject from UsersTags where idTag in
        (select idTag from Tags where tag like ?)
      )
    ;");
    $sth->execute(array("%$pattern%"));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
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
  //****************************************************************************
} ?>
