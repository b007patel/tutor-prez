use chemtest;

set @cur_suite = 0;
set @cur_case = 0;

set sql_mode = 'ANSI_QUOTES';

-- start Lookup table data
insert into "verify_type" values (1, 'Step', 'A regular step to balance a reaction. Shown by default.');
insert into "verify_type" values (2, 'Extra Step', 'An unabridged step to try to balance a reaction. Hidden by default.');
insert into "verify_type" values (3, 'Error', 'An error in the reaction input.');
insert into "verify_type" values (4, 'Warning', 'A warning about the reaction input.');
insert into "verify_type" values (5, 'Worksheet', 'A comma-delimited worksheet row of form <step number>, <element symbol>, <reactant count>, <product count>.');
-- end Lookup table data

-- start Simple test suite
insert into "test_suite" ("suite_desc") values ('Simple tests');
select last_insert_id() into @cur_suite;

insert into "test_case" ("case_desc", "case_exec") values (
    'Already balanced',
    'Zn + CuSO4 = Cu + ZnSO4');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Slight balancing',
    'Zn + Cu2SO4 = Cu + ZnSO4');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Slight balancing - polyatomic ions with subscripts',
    'Zn + Al2(SO4)3 = Al + ZnSO4');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Moderate balancing - other elements + O',
    'K2MnO4 + CO2 = KMnO4 + K2CO3 + MnO2');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Moderate balancing - 3 elements, O, H and one more',
    'CO2 + H2O = C6H12O6 + O2');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Only H and O to balance',
    'H2 + O2 = H2O');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

-- end Simple test suite
commit;

-- start Negative Assertion test suite
insert into "test_suite" ("suite_desc") values ('Negative assertion tests');
select last_insert_id() into @cur_suite;

insert into "test_case" ("case_desc", "case_exec") values (
    'Element starts with lower case letter',
    'jU7Nk3 = jU3 + Nk2');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Element not in periodic table',
    'Yt7 + P17 = P4Yt10');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'No products given',
    'K2MnO4 + CO2');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'One side has more elements than the other',
    'Al + NO3 = Al(NO3)2 + H2O');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Same number of elements on each side, but they are different',
    'Al + NO3 + P4 = Al(NO3)2 + H2O');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'No reactants given',
    '  = DyW + NH3');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'More than max number of steps reached',
    'H2O2 = H2O + O2');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

/*
-- mess around with the large fake polyatomic ion in this reaction to check
   all the error cases for pa ions (e.g., bracketing errors, only one element
   in brackets, no subscript after a right bracket)
-- might be worth it to add those test cases to this file
*/
insert into "test_case" ("case_desc", "case_exec") values (
    'Cannot balance - Many complex PA ions',
    'Al + NO3 + HCl + U7 + Cl2 + S8 = Al(NO3)2 + H2O + (NO4)7(U2H)8(Cl5H6S4)50');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Cannot balance - a few PA ions',
    'K4Fe(CN)6 + KMnO4 + H2SO4 = KHSO4 + Fe2(SO4)3 + MnSO4 + HNO3 + CO2 + H2O');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Cannot balance - one PA ion',
    'K2MnO4 + Cl2 = KMnO4 + KCl');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

-- end Negative Assertion test suite
commit;

-- start Complex test suite
insert into "test_suite" ("suite_desc") values ('Complex tests');
select last_insert_id() into @cur_suite;

insert into "test_case" ("case_desc", "case_exec") values (
    'Warning - last term after "=" ignored',
    'K2MnO4 + CO2 = KMnO4 + K2CO3 + MnO2 = PO');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Anion and cation with same element',
    'NaNO3 + NH4OH = NaH + NH4NO3 + HNO3');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Anion and cation with same element, reactants in reverse order',
    'NH4OH + NaNO3 = NaH + NH4NO3 + HNO3');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Balance with same PA ion on both sides of the equation, but with different counts',
    '(NH4)2CO3 + AlPO4 = (NH4)3PO4 + Al2(CO3)3');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Balanced but coefficients reduced at end',
    'C4H10 + O2 = CO2 + H2O');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Balanced but coefficients reduced at end - both sides reversed',
    'O2 + C4H10 = H2O + CO2');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Large coefficients - test Z* element boundary case',
    'Zn7 + P17 = P4Zn10');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Large coefficients with O and another element',
    'O7 + P17 = P4O10');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Large coefficients with O and another element - reactants reversed',
    'P17 + O7 = P4O10');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

insert into "test_case" ("case_desc", "case_exec") values (
    'Two PA ions with O resulting in only one PA ion with O',
    'MnO2 +  KOH + O2 = K2MnO4 + H2O');
select last_insert_id() into @cur_case;
insert into "suite_case" values (@cur_suite, @cur_case);

-- end Complex test suite
commit;

\. test_case_data.sql
