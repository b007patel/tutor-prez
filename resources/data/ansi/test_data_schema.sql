--drop database if exists chemtest;
--
--create database chemtest;
--
--use chemtest;

create table "test_case" (
    "case_id" integer not null auto_increment primary key
    comment 'Test case PK',
    "case_desc" char(255) not null comment 'Test case description',
    "case_exec" char(100) not null 
    comment 'Test case execution text, the reaction to test'
);

create table "test_suite" (
    "suite_id" integer not null auto_increment primary key
    comment 'Test suite PK',
    "suite_desc" char(255) not null comment 'Test suite description'
);

create table "suite_case" (
    "suite_id" integer not null,
    "case_id" integer not null,
    foreign key ("suite_id") references "test_suite"("suite_id"),
    foreign key ("case_id") references "test_case"("case_id"),
    primary key ("suite_id", "case_id")
);

create table "verify_type" (
    "type_id" integer not null primary key,
    "type_name" varchar(50) not null 
    comment 'Verification method name',
    "type_desc" varchar(255) not null 
    comment 'Verification method description'
);

create table "verify_reaction" (
    "vr_id" integer not null auto_increment primary key
    comment 'Verification reaction row PK',
    "reaction_type" integer not null 
    comment 'Type of reaction: 1 for starting, 2 for balanced',
    "case_id" integer not null,
    "vr_text" text(2000) not null 
    comment 'Verification reaction HTML to be confirmed',
    foreign key ("case_id") references "test_case"("case_id")
);

create table "verify_step" (
    "vs_id" integer not null auto_increment primary key
    comment 'Verification step PK',
    "vs_type_id" integer not null,
    "case_id" integer not null,
    "vs_text" varchar(255) not null 
    comment 'Verification step HTML to be confirmed',
    foreign key ("vs_type_id") references "verify_type"("type_id"),
    foreign key ("case_id") references "test_case"("case_id")
);

