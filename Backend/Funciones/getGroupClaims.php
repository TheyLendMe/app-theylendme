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
$GroupsClaims = new GroupsClaims($pdo);
$authManager = new AuthManager($Users);

//Auth & checking
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');
$group = $Groups->getGroup($neededArgs['idGroup']);
if ($group == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ($member === false) ResponseManager::returnErrorResponse('permission');

//Request logic
//IntraGroup claims && claims from others groups
$ClaimsReceived = $GroupsClaims->getClaimsToGroup($neededArgs['idGroup']);
//IntraGroup claims && claims to others groups && users
$ClaimsDone = $GroupsClaims->getClaimsByGroup($neededArgs['idGroup']);

if ($ClaimsReceived == null) $ClaimsReceived = [];
if ($ClaimsDone == null) $ClaimsDone = [];

$intraGroup = [];
$fromOthersGroups = [];
$toOthersGroups = [];
$toOthersUsers = [];

//Extract intragroup & claims from others
foreach ($ClaimsReceived as &$claim) {
  $loan = $GroupsLoans->getLoan($claim['idLoan']);
  $user = $Users->getUser($loan['idUser']);
  $claim['targetUser'] = $user;

  $obj = $GroupsObjects->getObject($loan['idObject']);
  $claim['object'] = $obj;

  if ($obj['idGroup'] == $loan['idGroup']){
    $intraGroup[] = $claim;
  }else{
    $claimingGroup = $Groups->getGroup($obj['idGroup']);
    $claim['claimingGroup'] = $claimingGroup;
    $fromOthersGroups[] = $claim;
  }
}

//Extract claim to others users && others groups
foreach ($ClaimsDone as &$claim) {
  //Ignore intraGroups
  $loan = $GroupsLoans->getLoan($claim['idLoan']);
  $obj = $GroupsObjects->getObject($loan['idObject']);
  if ($loan['idGroup'] == $obj['idGroup']){
    continue;
  }

  $user = $Users->getUser($loan['idUser']);
  $claim['keeper_user'] = $user;
  $claim['object'] = $obj;

  if ($loan['idGroup'] == null){
    $toOthersUsers[] = $claim;
  }else{
    $keeperGroup = $Groups->getGroup($loan['idGroup']);
    $claim['keeperGroup'] = $keeperGroup;
    $toOthersGroups[] = $claim;
  }
}

//Response
$admin = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $neededArgs['idGroup']);

$json['intraGroup'] = $intraGroup;
$json['fromOthersGroups'] = $fromOthersGroups;
if ($admin === true){
  $json['toOthersGroups'] = $toOthersGroups;
  $json['toOthersUsers'] = $toOthersUsers;
}

ResponseManager::returnSuccessResponse(3, $json);
?>
