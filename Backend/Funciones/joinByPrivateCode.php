<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'privateCode'
]);

//Logic
$GroupsMembers = new GroupsMembers($pdo);
$Groups = new Groups($pdo);
$JoinRequests = new JoinRequests($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

//Check the code
$grps = $Groups->getGroup(); //< get all groups
$correct_code = false;
foreach ($grps as &$g) {
  $correct_code = PrivateCodeManager::checkPrivateCode(
    $neededArgs['privateCode'],
    $g['idGroup'],
    $g['foundDate']
  );
  if ($correct_code === true) { //Save the target group
    $idGroup = intval($g['idGroup']);
    break;
  }
}
if ($correct_code === false) ResponseManager::returnErrorResponse('invalidCode');

//Check that he is not a member
$member = $GroupsMembers->isMember($neededArgs['idUser'], $idGroup);
if ($member === true) ResponseManager::returnErrorResponse('member');

//Join the group
$id = $GroupsMembers->addMember($neededArgs['idUser'], $idGroup);
if ($id == null) ResponseManager::returnErrorResponse('invalidData');
//Delete posible requests already done
$requested = $JoinRequests->haveRequestToGroup($neededArgs['idUser'], $idGroup);
if ( ($id != null) && ($requested === true) ){
    $req = $JoinRequests->getRequestsByUser($neededArgs['idUser'], $idGroup);
    $JoinRequests->removeRequest($req['idRequest']);
}

//Return
$memberInstance = $GroupsMembers->getMember($id);
$joinedGroup = $Groups->getGroup($memberInstance['idGroup']);
unset($memberInstance['idGroup']);
$memberInstance['group'] = $joinedGroup;

$json['member'] = $memberInstance;
ResponseManager::returnSuccessResponse(2, $json);
?>
