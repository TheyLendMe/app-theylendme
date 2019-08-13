<?php
$user = $_POST['idUser'];
$query = 'select * from Users where idUser="'.$user.'";';
print($query."\n");

//NORMAL SQL INJECTION
// $pdo->query($query);
// foreach ($pdo->query($query) as $row) {
//   print_r($row);
// }

//BLIND SQL INYECTION
// $pdo->query($query);
// print("Hey"."\n");
?>
