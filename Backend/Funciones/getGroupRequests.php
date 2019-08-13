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
$GroupsRequests = new GroupsRequests($pdo);
$authManager = new AuthManager($Users);

//Auth & checking
$auth = $authManager->verifyAuth($neededArgs['idUser'], $neededArgs['token']);
if ($auth === false) ResponseManager::returnErrorResponse('auth');
$group = $Groups->getGroup($neededArgs['idGroup']);
if ($group == null) ResponseManager::returnErrorResponse('invalidData');
$member = $GroupsMembers->isMember($neededArgs['idUser'], $neededArgs['idGroup']);
if ($member === false) ResponseManager::returnErrorResponse('permission');

//Request logic
//IntraGroup requests && requestsToOthersGroups
$groupRequests = $GroupsRequests->getRequestsByGroup($neededArgs['idGroup']);
//IntraGroup requests && requestsByOthersGroups && requestsByUsers
$receivedRequests = $GroupsRequests->getRequestsToGroup($neededArgs['idGroup']);
if ($groupRequests == null) $groupRequests = [];
if ($receivedRequests == null) $receivedRequests = [];

$intraGroup = [];
$extraGroupOut = [];
$extraGroupIn = [];
$extraUserIn= [];

//Extract intragroup & requests to others
foreach ($groupRequests as &$request) {
  $user = $Users->getUser($request['idUser']);
  unset($request['idUser']);
  $request['requester_user'] = $user;

  $obj = $GroupsObjects->getObject($request['idObject']);
  unset($request['idObject']);
  $request['object'] = $obj;

  if ($obj['idGroup'] == $request['idGroup']){
    unset($request['idGroup']);
    $intraGroup[] = $request;
  }else{
    $groupTarget = $Groups->getGroup($obj['idGroup']);
    unset($request['idGroup']);
    $request['groupTarget'] = $groupTarget;
    $extraGroupOut[] = $request;
  }
}

//Extract requests from others users && others groups
foreach ($receivedRequests as &$request) {
  //ignore intraGroups
  $obj = $GroupsObjects->getObject($request['idObject']);
  if ($obj['idGroup'] == $request['idGroup']){
    continue;
  }

  $user = $Users->getUser($request['idUser']);
  unset($request['idUser']);
  $request['requester_user'] = $user;

  unset($request['idObject']);
  $request['object'] = $obj;

  if ($request['idGroup'] == null){
    unset($request['idGroup']);
    $extraUserIn[] = $request;
  }else{
    $requesterGroup = $Groups->getGroup($request['idGroup']);
    unset($request['idGroup']);
    $request['requesterGroup'] = $requesterGroup;
    $extraGroupIn[] = $request;
  }
}

//Response
$json['intraGroup'] = $intraGroup;
$json['toOthersGroups'] = $extraGroupOut;
$json['fromOthersGroups'] = $extraGroupIn;
$json['fromOthersUsers'] = $extraUserIn;

ResponseManager::returnSuccessResponse(3, $json);
?>
