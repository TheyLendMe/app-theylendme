<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);

//Logic
$GroupsMembers = new GroupsMembers($pdo);
$Groups = new Groups($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$GroupsLoans = new GroupsLoans($pdo);
$Users = new Users($pdo);
$authManager = new AuthManager($Users);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$grp = $Groups->getGroup($neededArgs['idGroup']);
if ($grp == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ($member === false) ResponseManager::returnErrorResponse('permission');
// }

$Inventary = array(
  'our_objs' => [],
  'elses_objs' => []
);

//Add the groups's objects
$objects = $GroupsObjects->getObjects($neededArgs['idGroup']);
if ($objects == null) $objects = [];
foreach ($objects as &$obj) {
  $max_amount = $obj['amount'];
  $lent_amount = $GroupsLoans->getLentAmountByObject($obj['idObject']);
  $available_amount = $max_amount - $lent_amount;
  unset($obj['amount']);
  $obj['max_amount'] = $max_amount;
  $obj['available_amount'] = $available_amount;

  $owner_grp = $Groups->getGroup($obj['idGroup']);
  unset($obj['idGroup']);
  $obj['owner'] = $owner_grp;

  $Inventary['our_objs'][] = $obj;
}

//Add the lent objects
$loans = $GroupsLoans->getLoansToGroup($neededArgs['idGroup']);
if ($loans == null) $loans = [];
foreach ($loans as &$loan) {
  $obj = $GroupsObjects->getObject($loan['idObject']);
  $owner_grp = $Groups->getGroup($obj['idGroup']);
  unset($obj['idGroup']);
  $obj['owner'] = $owner_grp;

  $Inventary['elses_objs'][] = $obj;
}

//Return
ResponseManager::returnSuccessResponse(3, $Inventary);
?>
