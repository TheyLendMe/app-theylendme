<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token'
]);

//Logic
$UsersObjects = new UsersObjects($pdo);
$UsersLoans = new UsersLoans($pdo);
$Users = new Users($pdo);
$authManager = new AuthManager($Users);

$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$Inventary = array(
  'mine_objs' => [],
  'elses_objs' => []
);

//Add the users's objects
$objects = $UsersObjects->getObjects($neededArgs['idUser']);
if ($objects == null) $objects = [];
foreach ($objects as &$obj) {
  $max_amount = $obj['amount'];
  $lent_amount = $UsersLoans->getLentAmountByObject($obj['idObject']);
  $available_amount = $max_amount - $lent_amount;
  unset($obj['amount']);
  $obj['amount'] = $max_amount;
  $obj['available_amount'] = $available_amount;

  $usr = $Users->getUser($obj['idUser']);
  unset($obj['idUser']);
  $obj['owner'] = $usr;

  $Inventary['mine_objs'][] = $obj;
}

//Add the lent objects
$loans = $UsersLoans->getLoansToUser($neededArgs['idUser']);
if ($loans == null) $loans = [];
foreach ($loans as &$loan) {
  $obj = $UsersObjects->getObject($loan['idObject']);
  $usr = $Users->getUser($obj['idUser']);
  unset($obj['idUser']);
  $obj['owner'] = $usr;

  $Inventary['elses_objs'][] = $obj;
}

//Return
ResponseManager::returnSuccessResponse(3, $Inventary);
?>
