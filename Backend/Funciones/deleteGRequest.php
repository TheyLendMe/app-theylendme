<?php
//Required & optional arguments
$neededArgs = ArgumentManager::requirePostArguments([
  'idUser',
  'token',
  'idRequest'
]);

//Class instances
$GroupsMembers = new GroupsMembers($pdo);
$Groups = new Groups($pdo);
$GroupsObjects = new GroupsObjects($pdo);
$GroupsRequests = new GroupsRequests($pdo);
$usersInstance = new Users($pdo);
$authManager = new AuthManager($usersInstance);

//Auth {
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');

$request = $GroupsRequests->getRequest($neededArgs['idRequest']);
if ($request == null) ResponseManager::returnErrorResponse('invalidData');
$obj = $GroupsObjects->getObject($request['idObject']);
if ($obj == null) ResponseManager::returnErrorResponse('invalidData');
$grp = $Groups->getGroup($obj['idGroup']);
if ($grp == null) ResponseManager::returnErrorResponse('invalidData');

//Permission check
$admin_of_owner_group = $GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $grp['idGroup']);
$intraRequest_requester = ( ($request['idUser'] === $neededArgs['idUser']) && ($request['idGroup'] === $obj['idGroup']) );
$asUser_requester = ( ($request['idUser'] === $neededArgs['idUser']) && ($request['idGroup'] == null) );
$asGroup_requester = ( ($request['idUser'] === $neededArgs['idUser']) && ($request['idGroup'] != $obj['idGroup']) );
$asGroup_admin = ( ($request['idGroup'] != $obj['idGroup']) && ($GroupsMembers->isMemberAndAdmin($neededArgs['idUser'], $request['idGroup']) === true ) );

if (!( //Allow the following posibilities
  ($admin_of_owner_group === true) ||     //Admin of the owner group
  ($intraRequest_requester === true) ||   //User who made a intraRequest
  ($asUser_requester === true) ||         //User who made a request to a group by himself
  ($asGroup_requester === true) ||        //User who made a request to another group as a group
  ($asGroup_admin === true)               //Admin of the requester group in the case above
)) ResponseManager::returnErrorResponse('permission');
// }

//Delete the request
$deleted = $GroupsRequests->deleteRequest($neededArgs['idRequest']);

//Return
$json['deleted'] = $deleted;
ResponseManager::returnSuccessResponse(2, $json);
?>
