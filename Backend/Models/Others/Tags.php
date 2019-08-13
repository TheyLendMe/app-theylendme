<?php class Tags{

  //Class contructor
  public function Tags($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'Tags';
  }

  //Creates a new tag if it dont exists yet, return the id
  function createTag($tag){
    if ($tag == null) return null;

    $sth = $this->pdo->prepare("select idTag from $this->tableName where tag = ?;");
    $sth->execute(array($tag));
    $exists = ($sth->rowCount() === 0 ? false : true);

    if ($exists){
      $idTag = $sth->fetch(PDO::FETCH_ASSOC)['idTag'];
      return $idTag;
    }else{
      $sth = $this->pdo->prepare("Insert into $this->tableName (tag) values (?);");
      $sth->execute(array($tag));
      $lastId = $this->pdo->lastInsertId();
      return $lastId;
    }
  }

  //Delete a tag by its id
  function deleteTag($idTag){
    if ($idTag == null) return false;

    $sth = $this->pdo->prepare("delete from $this->tableName where idTag = ?;");
    $sth->execute(array($idTag));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

  //Get all the tags asociated to one user object
  function getTagsByUserObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where
      idTag in (select idTag from UsersTags where idObject = ?);");
    $sth->execute(array($idObject));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Get all the tags asociated to one group object
  function getTagsByGroupObject($idObject){
    if ($idObject == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where
      idTag in (select idTag from GroupsTags where idObject = ?);");
    $sth->execute(array($idObject));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return all the tags which match a pattern
  function getTagsByTag($pattern){
    if ($pattern == null) return null;

    $sth = $this->pdo->prepare("select * from $this->tableName where tag like ?;");
    $sth->execute(array("%$pattern%"));
    while( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
      $data[] = $row;
    }
    return $data;
  }

  //Return a tag by its id
  function getTag($idTag){
    if ($idTag == null) return null;

    $sth = $this->pdo->prepare("Select * from $this->tableName where idTag = ?;");
    $sth->execute(array($idTag));
    $data = $sth->fetch(PDO::FETCH_ASSOC);
    return $data;
  }
} ?>
