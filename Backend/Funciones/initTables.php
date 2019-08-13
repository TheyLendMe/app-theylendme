<?php
if (!($_POST['passwd'] === 'root')) die();
//schema design at https://www.dbdesigner.net/designer/schema/202655
//DROP TABLES
//The order is inverse due to freign key constrains
$pdo->query('drop table if exists UsersRequests;');
$pdo->query('drop table if exists UsersClaims;');
$pdo->query('drop table if exists UsersLoans;');
$pdo->query('drop table if exists UsersHistory;');
$pdo->query('drop table if exists UsersTags;');
$pdo->query('drop table if exists UsersEstadistics;');
$pdo->query('drop table if exists GroupsRequests;');
$pdo->query('drop table if exists GroupsClaims;');
$pdo->query('drop table if exists GroupsLoans;');
$pdo->query('drop table if exists GroupsHistory;');
$pdo->query('drop table if exists GroupsTags;');
$pdo->query('drop table if exists Tags;');
$pdo->query('drop table if exists GroupsMembers;');
$pdo->query('drop table if exists JoinRequests;');
$pdo->query('drop table if exists UsersObjects;');
$pdo->query('drop table if exists GroupsObjects;');
$pdo->query('drop table if exists Groups;');
$pdo->query('drop table if exists Users;');

//CREATE TABLES
//userTables
$pdo->query('create table Users (
  idUser varchar(50) primary key not null,
  nickname varchar(25),
  email varchar(180),
  tfno varchar(20),
  info varchar(255),
  imagen varchar(255),
  signUpDate date not null
);');
$pdo->query('create table UsersObjects (
  idObject int primary key auto_increment not null,
  idUser varchar(50) not null,
  imagen varchar(255),
  amount int not null default 1,
  name varchar(50),
  descr varchar(255),
  creationDate date not null,
  foreign key (idUser) references Users(idUser) on delete cascade
);');
$pdo->query('create table UsersRequests (
  idRequest int primary key auto_increment not null,
  idUser varchar(50) not null,
  idObject int not null,
  amount int not null default 1,
  date date not null,
  requestMsg varchar(200),
  foreign key (idUser) references Users(idUser) on delete cascade,
  foreign key (idObject) references UsersObjects(idObject) on delete cascade
);');
$pdo->query('create table UsersLoans (
  idLoan int primary key auto_increment not null,
  idUser varchar(50) not null,
  idObject int not null,
  amount int not null default 1,
  date date not null,
  foreign key (idUser) references Users(idUser) on delete cascade,
  foreign key (idObject) references UsersObjects(idObject) on delete cascade
);');
$pdo->query('create table UsersClaims (
  idClaim int primary key auto_increment not null,
  idLoan int not null,
  claimMsg varchar(200),
  claimDate date not null,
  foreign key (idLoan) references UsersLoans(idLoan) on delete cascade
);');

//groupTables
$pdo->query('create table Groups (
  idGroup int primary key auto_increment not null,
  groupName varchar(50),
  private bit not null default 1,
  autoloan bit not null default 0,
  email varchar(180),
  tfno varchar(20),
  info varchar(255),
  imagen varchar(255),
  foundDate date not null
);');
$pdo->query('create table GroupsObjects (
  idObject int primary key auto_increment not null,
  idGroup int not null,
  imagen varchar(255),
  amount int not null default 1,
  name varchar(50),
  descr varchar(255),
  creationDate date not null,
  foreign key (idGroup) references Groups(idGroup) on delete cascade
);');
$pdo->query('create table GroupsRequests (
  idRequest int primary key auto_increment not null,
  idGroup int,
  idUser varchar(50),
  idObject int not null,
  amount int not null default 1,
  date date not null,
  requestMsg varchar(200),
  foreign key (idGroup) references Groups(idGroup) on delete cascade,
  foreign key (idUser) references Users(idUser) on delete cascade,
  foreign key (idObject) references GroupsObjects(idObject) on delete cascade
);');
$pdo->query('create table GroupsLoans (
  idLoan int primary key auto_increment not null,
  idGroup int,
  idUser varchar(50) not null,
  idObject int not null,
  amount int not null default 1,
  date date not null,
  foreign key (idGroup) references Groups(idGroup) on delete cascade,
  foreign key (idUser) references Users(idUser) on delete cascade,
  foreign key (idObject) references GroupsObjects(idObject) on delete cascade
);');
$pdo->query('create table GroupsClaims (
  idClaim int primary key auto_increment not null,
  idLoan int not null,
  claimMsg varchar(200),
  claimDate date not null,
  foreign key (idLoan) references GroupsLoans(idLoan) on delete cascade
);');

//history & estadistics
$pdo->query('create table UsersHistory (
  idHistory int primary key auto_increment not null,
  idUser varchar(50) not null,
  idObject int not null,
  transactionDate date not null,
  amount int not null default 1,
  returned bit not null,
  foreign key (idUser) references Users(idUser) on delete cascade,
  foreign key (idObject) references UsersObjects(idObject) on delete cascade
);');
$pdo->query('create table UsersEstadistics (
  idUser varchar(50) primary key not null,
  objectsPublished int not null default 0,
  loansDone int not null default 0,
  loansReceived int not null default 0,
  loansReturned int not null default 0,
  foreign key (idUser) references Users(idUser) on delete cascade
);');
$pdo->query('create table GroupsHistory (
  idHistory int primary key auto_increment not null,
  doner varchar(50) not null,
  recipient varchar(50) not null,
  idGroup int,
  idObject int not null,
  transactionDate date not null,
  amount int not null default 1,
  returned bit not null,
  foreign key (doner) references Users(idUser) on delete cascade,
  foreign key (recipient) references Users(idUser) on delete cascade,
  foreign key (idGroup) references Groups(idGroup) on delete cascade,
  foreign key (idObject) references GroupsObjects(idObject) on delete cascade
);');
//Tags
$pdo->query('create table Tags (
  idTag int primary key auto_increment not null,
  tag varchar(20) not null
);');

//relational
$pdo->query('create table GroupsMembers (
  idMember int primary key auto_increment not null,
  idUser varchar(50) not null,
  idGroup int not null,
  admin bit not null default 0,
  foreign key (idUser) references Users(idUser) on delete cascade,
  foreign key (idGroup) references Groups(idGroup) on delete cascade
);');
$pdo->query('create table JoinRequests (
  idRequest int primary key auto_increment not null,
  idUser varchar(50) not null,
  idGroup int not null,
  foreign key (idUser) references Users(idUser) on delete cascade,
  foreign key (idGroup) references Groups(idGroup) on delete cascade
);');
$pdo->query('create table UsersTags (
  idLink int primary key auto_increment not null,
  idTag int not null,
  idObject int not null,
  foreign key (idTag) references Tags(idTag) on delete cascade,
  foreign key (idObject) references UsersObjects(idObject) on delete cascade
);');
$pdo->query('create table GroupsTags (
  idLink int primary key auto_increment not null,
  idTag int not null,
  idObject int not null,
  foreign key (idTag) references Tags(idTag) on delete cascade,
  foreign key (idObject) references GroupsObjects(idObject) on delete cascade
);');

print("tables droped and created"."</br>"."\n");
?>
