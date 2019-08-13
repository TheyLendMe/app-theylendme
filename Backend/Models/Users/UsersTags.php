<?php class UsersTags{

  //Class contructor
  public function UsersTags($pdo_conn) {
    $this->pdo = $pdo_conn;
    $this->tableName = 'UsersTags';
  }

  //creates a relation into object and tag
  function createTagLink($idTag, $idObject){
    if ($idTag == null || $idObject == null) return false;

    $sth = $this->pdo->prepare("Insert into $this->tableName (idTag, idObject) values (?, ?);");
    $sth->execute(array($idTag, $idObject));
    $lastId = $this->pdo->lastInsertId();
    return $lastId;
  }

  //Delete a tag by its id
  function deleteTagLink($idLink){
    if ($idLink == null) return false;

    $sth = $this->pdo->prepare("delete from $this->tableName where idLink = ?;");
    $sth->execute(array($idLink));
    $del = $sth->rowCount();
    return ($del === 0 ? false : true);
  }

} ?>
