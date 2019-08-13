<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idGroup'
]);

//Class declarations
$Users = new Users($pdo);
$Groups = new Groups($pdo);
$GroupsMembers = new GroupsMembers($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$GroupsLoans = new GroupsLoans($pdo);
$authManager = new AuthManager($Users);

//Auth & checking
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$group = $Groups->getGroup($neededArgs['idGroup']);
if ($group == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ($member === false) ResponseManager::returnErrorResponse('permission');

//Request logic
//IntraGroup loan && loans from others groups
$LoansReceived = $GroupsLoans->getLoansToGroup($neededArgs['idGroup']);
//loansToOthersGroups && loans to users
$LoansDone = $GroupsLoans->getLoansByGroup($neededArgs['idGroup']);

if ($LoansReceived == null) $LoansReceived = [];
if ($LoansDone == null) $LoansDone = [];

$intraGroup = [];
$fromOthersGroups = [];
$toOthersGroups = [];
$toOthersUsers = [];

//Extract intragroup & loans from to others
foreach ($LoansReceived as &$loan) {
  $user = $Users->getUser($loan['idUser']);
  unset($loan['idUser']);
  $loan['keeper_user'] = $user;

  $obj = $GroupsObjects->getObject($loan['idObject']);
  unset($loan['idObject']);
  $loan['object'] = $obj;

  if ($obj['idGroup'] == $loan['idGroup']){
    unset($loan['idGroup']);
    $intraGroup[] = $loan;
  }else{
    $ownerGroup = $Groups->getGroup($obj['idGroup']);
    unset($loan['idGroup']);
    $loan['ownerGroup'] = $ownerGroup;
    $fromOthersGroups[] = $loan;
  }
}

//Extract loans to others users && others groups
foreach ($LoansDone as &$loan) {
  //Ignore intraGroups
  $obj = $GroupsObjects->getObject($loan['idObject']);
  if ($loan['idGroup'] == $obj['idGroup']){
    continue;
  }

  $user = $Users->getUser($loan['idUser']);
  unset($loan['idUser']);
  $loan['keeper_user'] = $user;

  $obj = $GroupsObjects->getObject($loan['idObject']);
  unset($loan['idObject']);
  $loan['object'] = $obj;

  if ($loan['idGroup'] == null){
    unset($loan['idGroup']);
    $toOthersUsers[] = $loan;
  }else{
    $keeperGroup = $Groups->getGroup($loan['idGroup']);
    unset($loan['idGroup']);
    $loan['keeperGroup'] = $keeperGroup;
    $toOthersGroups[] = $loan;
  }
}

//Response
$json['intraGroup'] = $intraGroup;
$json['fromOthersGroups'] = $fromOthersGroups;
$json['toOthersGroups'] = $toOthersGroups;
$json['toOthersUsers'] = $toOthersUsers;

ResponseManager::returnSuccessResponse(3, $json);
?>
