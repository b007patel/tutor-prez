-- mysql-specific preamble, if any
set sql_mode='ANSI_QUOTES';
use chemtest;
-- end mysql preamble

-- Test case 1, Already balanced
-- Reaction: Zn + CuSO4 = Cu + ZnSO4
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 1,
    '<span class="cpd_Zn"> <span class="coef_Zn"></span><span class="eall_Zn erx_Zn">Zn</span></span> +  <span class="cpd_CuSO4"> <span class="coef_CuSO4"></span><span class="eall_Cu erx_Cu">Cu</span><span class="eall_S erx_S">S</span><span class="eall_O erx_O">O<sub>4</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_Cu"> <span class="coef_Cu"></span><span class="eall_Cu epd_Cu">Cu</span></span> +  <span class="cpd_ZnSO4"> <span class="coef_ZnSO4"></span><span class="eall_Zn epd_Zn">Zn</span><span class="eall_S epd_S">S</span><span class="eall_O epd_O">O<sub>4</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 1,
    '<span class="cpd_Zn"> <span class="coef_Zn"></span><span class="eall_Zn erx_Zn">Zn</span></span> +  <span class="cpd_CuSO4"> <span class="coef_CuSO4"></span><span class="eall_Cu erx_Cu">Cu</span><span class="eall_S erx_S">S</span><span class="eall_O erx_O">O<sub>4</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_Cu"> <span class="coef_Cu"></span><span class="eall_Cu epd_Cu">Cu</span></span> +  <span class="cpd_ZnSO4"> <span class="coef_ZnSO4"></span><span class="eall_Zn epd_Zn">Zn</span><span class="eall_S epd_S">S</span><span class="eall_O epd_O">O<sub>4</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 1,
    '1|Starting equation was already balanced.');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 1,
    '1,Zn,1,1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 1,
    '1,Cu,1,1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 1,
    '1,O,4,4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 1,
    '1,S,1,1');

-- Test case 2, Slight balancing
-- Reaction: Zn + Cu2SO4 = Cu + ZnSO4
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 2,
    '<span class="cpd_Zn"> <span class="coef_Zn"></span><span class="eall_Zn erx_Zn">Zn</span></span> +  <span class="cpd_Cu2SO4"> <span class="coef_Cu2SO4"></span><span class="eall_Cu erx_Cu">Cu<sub>2</sub></span><span class="eall_S erx_S">S</span><span class="eall_O erx_O">O<sub>4</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_Cu"> <span class="coef_Cu"></span><span class="eall_Cu epd_Cu">Cu</span></span> +  <span class="cpd_ZnSO4"> <span class="coef_ZnSO4"></span><span class="eall_Zn epd_Zn">Zn</span><span class="eall_S epd_S">S</span><span class="eall_O epd_O">O<sub>4</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 2,
    '<span class="cpd_Zn"> <span class="coef_Zn"></span><span class="eall_Zn erx_Zn">Zn</span></span> +  <span class="cpd_Cu2SO4"> <span class="coef_Cu2SO4"></span><span class="eall_Cu erx_Cu">Cu<sub>2</sub></span><span class="eall_S erx_S">S</span><span class="eall_O erx_O">O<sub>4</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_Cu"> <span class="coef_Cu">2</span><span class="eall_Cu epd_Cu">Cu</span></span> +  <span class="cpd_ZnSO4"> <span class="coef_ZnSO4"></span><span class="eall_Zn epd_Zn">Zn</span><span class="eall_S epd_S">S</span><span class="eall_O epd_O">O<sub>4</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 2,
    '1|Consider compounds with element(s)  <span class="eall_Cu">Cu</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 2,
    '2|Try to balance <span class="epd_Cu">Cu</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 2,
    '3|new <span class="epd_Cu">Cu</span> coefficient is  <span class="coef_Cu">2</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 2,
    '3,Zn,1,1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 2,
    '3,Cu,2,2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 2,
    '3,O,4,4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 2,
    '3,S,1,1');

-- Test case 3, Slight balancing - polyatomic ions with subscripts
-- Reaction: Zn + Al2(SO4)3 = Al + ZnSO4
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 3,
    '<span class="cpd_Zn"> <span class="coef_Zn"></span><span class="eall_Zn erx_Zn">Zn</span></span> +  <span class="cpd_Al2-SO4-3"> <span class="coef_Al2-SO4-3"></span><span class="eall_Al erx_Al">Al<sub>2</sub></span>(<span class="eall_S erx_S">S</span><span class="eall_O erx_O">O<sub>4</sub></span>)<sub>3</sub></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_Al"> <span class="coef_Al"></span><span class="eall_Al epd_Al">Al</span></span> +  <span class="cpd_ZnSO4"> <span class="coef_ZnSO4"></span><span class="eall_Zn epd_Zn">Zn</span><span class="eall_S epd_S">S</span><span class="eall_O epd_O">O<sub>4</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 3,
    '<span class="cpd_Zn"> <span class="coef_Zn">3</span><span class="eall_Zn erx_Zn">Zn</span></span> +  <span class="cpd_Al2-SO4-3"> <span class="coef_Al2-SO4-3"></span><span class="eall_Al erx_Al">Al<sub>2</sub></span>(<span class="eall_S erx_S">S</span><span class="eall_O erx_O">O<sub>4</sub></span>)<sub>3</sub></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_Al"> <span class="coef_Al">2</span><span class="eall_Al epd_Al">Al</span></span> +  <span class="cpd_ZnSO4"> <span class="coef_ZnSO4">3</span><span class="eall_Zn epd_Zn">Zn</span><span class="eall_S epd_S">S</span><span class="eall_O epd_O">O<sub>4</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '1|Consider compounds with element(s)  <span class="eall_Al">Al</span>, <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '2|Try to balance <span class="epd_Al">Al</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '3|new <span class="epd_Al">Al</span> coefficient is  <span class="coef_Al">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '4|Consider compounds with element(s)  <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '5|Find difference in product count and reaction count of <span class="eall_S">S</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '6|Check compounds only with <span class="epd_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '7|Inspect products to see if compounds with S can be adjusted to balance S');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '8|No candidates found for S');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '9|Total <span class="epd_S">S</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '10|Check compounds with <span class="epd_S">S</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '11|Try to balance <span class="epd_S">S</span>\'s by multiplying products\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '12|new <span class="cpd_ZnSO4">ZnSO4</span> coefficient is  <span class="coef_ZnSO4">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '13|Consider compounds with element(s)  <span class="eall_Zn">Zn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '14|Find difference in product count and reaction count of <span class="eall_Zn">Zn</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '15|Check compounds only with <span class="erx_Zn">Zn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '16|Inspect reactants to see if compounds with Zn can be adjusted to balance Zn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '17|Check if the total <span class="erx_Zn">Zn</span> count on reactant side is a &gt\;1 factor of 2, the difference in <span class="erx_Zn">Zn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '18|2 is exactly 2 times larger than the reactant <span class="erx_Zn">Zn</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '19|Increase coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 3,
    '20|new <span class="erx_Zn">Zn</span> coefficient is  <span class="coef_Zn">3</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 3,
    '20,Zn,3,3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 3,
    '20,Al,2,2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 3,
    '20,O,12,12');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 3,
    '20,S,3,3');

-- Test case 4, Moderate balancing - other elements + O
-- Reaction: K2MnO4 + CO2 = KMnO4 + K2CO3 + MnO2
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 4,
    '<span class="cpd_K2MnO4"> <span class="coef_K2MnO4"></span><span class="eall_K erx_K">K<sub>2</sub></span><span class="eall_Mn erx_Mn">Mn</span><span class="eall_O erx_O">O<sub>4</sub></span></span> +  <span class="cpd_CO2"> <span class="coef_CO2"></span><span class="eall_C erx_C">C</span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_KMnO4"> <span class="coef_KMnO4"></span><span class="eall_K epd_K">K</span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_K2CO3"> <span class="coef_K2CO3"></span><span class="eall_K epd_K">K<sub>2</sub></span><span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>3</sub></span></span> +  <span class="cpd_MnO2"> <span class="coef_MnO2"></span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>2</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 4,
    '<span class="cpd_K2MnO4"> <span class="coef_K2MnO4">3</span><span class="eall_K erx_K">K<sub>2</sub></span><span class="eall_Mn erx_Mn">Mn</span><span class="eall_O erx_O">O<sub>4</sub></span></span> +  <span class="cpd_CO2"> <span class="coef_CO2">2</span><span class="eall_C erx_C">C</span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_KMnO4"> <span class="coef_KMnO4">2</span><span class="eall_K epd_K">K</span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_K2CO3"> <span class="coef_K2CO3">2</span><span class="eall_K epd_K">K<sub>2</sub></span><span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>3</sub></span></span> +  <span class="cpd_MnO2"> <span class="coef_MnO2"></span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>2</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '1|Consider compounds with element(s)  <span class="eall_K">K</span>, <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '2|Try to balance <span class="erx_K">K</span>\'s by multiplying reactants\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '3|new <span class="cpd_K2MnO4">K2MnO4</span> coefficient is  <span class="coef_K2MnO4">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '4|Try to balance <span class="epd_K">K</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '5|new <span class="cpd_KMnO4">KMnO4</span> coefficient is  <span class="coef_KMnO4">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '6|new <span class="cpd_K2CO3">K2CO3</span> coefficient is  <span class="coef_K2CO3">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '7|Consider compounds with element(s)  <span class="eall_C">C</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '8|Find difference in product count and reaction count of <span class="eall_C">C</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '9|Check compounds only with <span class="erx_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '10|Inspect reactants to see if compounds with C can be adjusted to balance C');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '11|Check if the total <span class="erx_C">C</span> count on reactant side is a &gt\;1 factor of 1, the difference in <span class="erx_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '12|1 is exactly 1 times larger than the reactant <span class="erx_C">C</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '13|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 4,
    '14|new <span class="cpd_CO2">CO2</span> coefficient is  <span class="coef_CO2">2</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 4,
    '14,K,6,6');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 4,
    '14,Mn,3,3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 4,
    '14,O,16,16');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 4,
    '14,C,2,2');

-- Test case 5, Moderate balancing - 3 elements, O, H and one more
-- Reaction: CO2 + H2O = C6H12O6 + O2
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 5,
    '<span class="cpd_CO2"> <span class="coef_CO2"></span><span class="eall_C erx_C">C</span><span class="eall_O erx_O">O<sub>2</sub></span></span> +  <span class="cpd_H2O"> <span class="coef_H2O"></span><span class="eall_H erx_H">H<sub>2</sub></span><span class="eall_O erx_O">O</span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_C6H12O6"> <span class="coef_C6H12O6"></span><span class="eall_C epd_C">C<sub>6</sub></span><span class="eall_H epd_H">H<sub>12</sub></span><span class="eall_O epd_O">O<sub>6</sub></span></span> +  <span class="cpd_O2"> <span class="coef_O2"></span><span class="eall_O epd_O">O<sub>2</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 5,
    '<span class="cpd_CO2"> <span class="coef_CO2">6</span><span class="eall_C erx_C">C</span><span class="eall_O erx_O">O<sub>2</sub></span></span> +  <span class="cpd_H2O"> <span class="coef_H2O">6</span><span class="eall_H erx_H">H<sub>2</sub></span><span class="eall_O erx_O">O</span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_C6H12O6"> <span class="coef_C6H12O6"></span><span class="eall_C epd_C">C<sub>6</sub></span><span class="eall_H epd_H">H<sub>12</sub></span><span class="eall_O epd_O">O<sub>6</sub></span></span> +  <span class="cpd_O2"> <span class="coef_O2">6</span><span class="eall_O epd_O">O<sub>2</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '1|Consider compounds with element(s)  <span class="eall_C">C</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '2|Try to balance <span class="erx_C">C</span>\'s by multiplying reactants\' coefficients by 6');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '3|new <span class="cpd_CO2">CO2</span> coefficient is  <span class="coef_CO2">6</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '4|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '5|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 10');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '6|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '7|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '8|Check if the total <span class="erx_H">H</span> count on reactant side is a &gt\;1 factor of 10, the difference in <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '9|10 is exactly 5 times larger than the reactant <span class="erx_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '10|Increase coefficients by 5');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '11|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">6</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '12|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '13|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 10');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '14|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '15|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '16|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 10, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '17|10 is exactly 5 times larger than the product <span class="epd_O">O</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '18|Increase coefficients by 5');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 5,
    '19|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">6</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 5,
    '19,C,6,6');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 5,
    '19,O,18,18');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 5,
    '19,H,12,12');

-- Test case 6, Only H and O to balance
-- Reaction: H2 + O2 = H2O
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 6,
    '<span class="cpd_H2"> <span class="coef_H2"></span><span class="eall_H erx_H">H<sub>2</sub></span></span> +  <span class="cpd_O2"> <span class="coef_O2"></span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_H2O"> <span class="coef_H2O"></span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 6,
    '<span class="cpd_H2"> <span class="coef_H2">2</span><span class="eall_H erx_H">H<sub>2</sub></span></span> +  <span class="cpd_O2"> <span class="coef_O2"></span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_H2O"> <span class="coef_H2O">2</span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '1|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '2|Try to balance <span class="epd_O">O</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '3|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '4|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '5|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '6|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '7|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '8|Check if the total <span class="erx_H">H</span> count on reactant side is a &gt\;1 factor of 2, the difference in <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '9|2 is exactly 1 times larger than the reactant <span class="erx_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '10|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 6,
    '11|new <span class="cpd_H2">H2</span> coefficient is  <span class="coef_H2">2</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 6,
    '11,H,4,4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 6,
    '11,O,2,2');

-- Test case 7, Element starts with lower case letter
-- Reaction: jU7Nk3 = jU3 + Nk2
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 7,
    'jU<sub>7</sub>Nk<sub>3</sub> <i class="fa fa-long-arrow-right fa-lg"></i> jU<sub>3</sub> + Nk<sub>2</sub>');

insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (3, 7,
    'Reactants:First element invalid: starts with lower-case letter');

-- Test case 8, Element not in periodic table
-- Reaction: Yt7 + P17 = P4Yt10
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 8,
    'Yt<sub>7</sub> + P<sub>17</sub> <i class="fa fa-long-arrow-right fa-lg"></i> P<sub>4</sub>Yt<sub>10</sub>');

insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (3, 8,
    'Reactants:Invalid element \'Yt\'');

-- Test case 9, No products given
-- Reaction: K2MnO4 + CO2
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 9,
    'K<sub>2</sub>MnO<sub>4</sub> + CO<sub>2</sub>');

insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (3, 9,
    'No products given!!');

-- Test case 10, One side has more elements than the other
-- Reaction: Al + NO3 = Al(NO3)2 + H2O
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 10,
    'Al + NO<sub>3</sub> <i class="fa fa-long-arrow-right fa-lg"></i> Al(NO<sub>3</sub>)<sub>2</sub> + H<sub>2</sub>O');

insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (3, 10,
    'There are 3 reactant elements, yet there are 4 product elements. These counts should be equal');

-- Test case 11, Same number of elements on each side, but they are different
-- Reaction: Al + NO3 + P4 = Al(NO3)2 + H2O
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 11,
    'Al + NO<sub>3</sub> + P<sub>4</sub> <i class="fa fa-long-arrow-right fa-lg"></i> Al(NO<sub>3</sub>)<sub>2</sub> + H<sub>2</sub>O');

insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (3, 11,
    'Reactant element P is not in any product');

-- Test case 12, No reactants given
-- Reaction:   = DyW + NH3
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 12,
    '<i class="fa fa-long-arrow-right fa-lg"></i> DyW + NH<sub>3</sub>');

insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (3, 12,
    'No reactants given!! Cannot start input with \'=\'');

-- Test case 13, More than max number of steps reached
-- Reaction: H2O2 = H2O + O2
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 13,
    '<span class="cpd_H2O2"> <span class="coef_H2O2"></span><span class="eall_H erx_H">H<sub>2</sub></span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_H2O"> <span class="coef_H2O"></span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span> +  <span class="cpd_O2"> <span class="coef_O2"></span><span class="eall_O epd_O">O<sub>2</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 13,
    '1|** # of steps exceeds max steps allowed (200)');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '2|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '3|Try to balance <span class="erx_O">O</span>\'s by multiplying reactants\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '4|new <span class="cpd_H2O2">H2O2</span> coefficient is  <span class="coef_H2O2">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '5|Try to balance <span class="epd_O">O</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '6|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '7|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '8|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '9|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '10|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '11|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '12|Check if the total <span class="epd_H">H</span> count on product side is a &gt\;1 factor of 2, the difference in <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '13|2 is exactly 1 times larger than the product <span class="epd_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '14|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '15|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '16|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '17|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '18|Check compounds only with <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '19|Inspect reactants to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '20|Check if the total <span class="erx_O">O</span> count on reactant side is a &gt\;1 factor of 1, the difference in <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '21|Total <span class="erx_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '22|Check compounds with <span class="erx_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '23|Try to balance <span class="erx_O">O</span>\'s by multiplying reactants\' coefficients by 21');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '24|new <span class="cpd_H2O2">H2O2</span> coefficient is  <span class="coef_H2O2">21</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '25|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '26|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 36');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '27|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '28|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '29|Check if the total <span class="epd_H">H</span> count on product side is a &gt\;1 factor of 36, the difference in <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '30|36 is exactly 18 times larger than the product <span class="epd_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '31|Increase coefficients by 18');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '32|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">21</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '33|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '34|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 17');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '35|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '36|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '37|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 17, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '38|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '39|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '40|Balance using <span class="cpd_H2O">H2O</span>, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '41|Balance using <span class="epd_O">O</span>2, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '42|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '43|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '44|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '45|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '46|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '47|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '48|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '49|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '50|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">22</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '51|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">10</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '52|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '53|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '54|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '55|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '56|Check if the total <span class="erx_H">H</span> count on reactant side is a &gt\;1 factor of 2, the difference in <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '57|2 is exactly 1 times larger than the reactant <span class="erx_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '58|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '59|new <span class="cpd_H2O2">H2O2</span> coefficient is  <span class="coef_H2O2">22</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '60|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '61|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '62|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '63|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '64|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 2, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '65|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '66|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '67|Balance using <span class="cpd_H2O">H2O</span>, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '68|Balance using <span class="epd_O">O</span>2, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '69|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '70|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2"></span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '71|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '72|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 40');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '73|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '74|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '75|Check if the total <span class="epd_H">H</span> count on product side is a &gt\;1 factor of 40, the difference in <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '76|40 is exactly 20 times larger than the product <span class="epd_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '77|Increase coefficients by 20');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '78|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">22</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '79|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '80|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 20');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '81|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '82|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '83|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 20, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '84|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '85|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '86|Balance using <span class="cpd_H2O">H2O</span>, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '87|Balance using <span class="epd_O">O</span>2, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '88|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '89|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '90|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '91|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '92|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '93|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '94|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '95|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '96|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '97|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">24</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '98|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">10</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '99|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '100|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '101|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '102|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '103|Check if the total <span class="erx_H">H</span> count on reactant side is a &gt\;1 factor of 4, the difference in <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '104|4 is exactly 2 times larger than the reactant <span class="erx_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '105|Increase coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '106|new <span class="cpd_H2O2">H2O2</span> coefficient is  <span class="coef_H2O2">24</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '107|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '108|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '109|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '110|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '111|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 4, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '112|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '113|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '114|Balance using <span class="cpd_H2O">H2O</span>, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '115|Balance using <span class="epd_O">O</span>2, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '116|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '117|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">26</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '118|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">11</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '119|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '120|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '121|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '122|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '123|Check if the total <span class="erx_H">H</span> count on reactant side is a &gt\;1 factor of 4, the difference in <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '124|4 is exactly 2 times larger than the reactant <span class="erx_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '125|Increase coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '126|new <span class="cpd_H2O2">H2O2</span> coefficient is  <span class="coef_H2O2">26</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '127|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '128|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '129|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '130|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '131|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 4, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '132|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '133|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '134|Balance using <span class="cpd_H2O">H2O</span>, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '135|Balance using <span class="epd_O">O</span>2, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '136|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '137|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">28</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '138|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">12</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '139|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '140|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '141|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '142|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '143|Check if the total <span class="erx_H">H</span> count on reactant side is a &gt\;1 factor of 4, the difference in <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '144|4 is exactly 2 times larger than the reactant <span class="erx_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '145|Increase coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '146|new <span class="cpd_H2O2">H2O2</span> coefficient is  <span class="coef_H2O2">28</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '147|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '148|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '149|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '150|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '151|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 4, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '152|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '153|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '154|Balance using <span class="cpd_H2O">H2O</span>, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '155|Balance using <span class="epd_O">O</span>2, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '156|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '157|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">30</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '158|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">13</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '159|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '160|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '161|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '162|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '163|Check if the total <span class="erx_H">H</span> count on reactant side is a &gt\;1 factor of 4, the difference in <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '164|4 is exactly 2 times larger than the reactant <span class="erx_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '165|Increase coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '166|new <span class="cpd_H2O2">H2O2</span> coefficient is  <span class="coef_H2O2">30</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '167|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '168|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '169|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '170|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '171|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 4, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '172|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '173|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '174|Balance using <span class="cpd_H2O">H2O</span>, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '175|Balance using <span class="epd_O">O</span>2, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '176|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '177|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">32</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '178|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">14</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '179|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '180|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '181|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '182|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '183|Check if the total <span class="erx_H">H</span> count on reactant side is a &gt\;1 factor of 4, the difference in <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '184|4 is exactly 2 times larger than the reactant <span class="erx_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '185|Increase coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '186|new <span class="cpd_H2O2">H2O2</span> coefficient is  <span class="coef_H2O2">32</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '187|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '188|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '189|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '190|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '191|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 4, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '192|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '193|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '194|Balance using <span class="cpd_H2O">H2O</span>, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '195|Balance using <span class="epd_O">O</span>2, which has a <span class="epd_O">O</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '196|Re-balance by changing coefficients of <span class="epd_O">O</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '197|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">34</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '198|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">15</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '199|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '200|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '201|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '202|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '203|Check if the total <span class="erx_H">H</span> count on reactant side is a &gt\;1 factor of 4, the difference in <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '204|4 is exactly 2 times larger than the reactant <span class="erx_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '205|Increase coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '206|new <span class="cpd_H2O2">H2O2</span> coefficient is  <span class="coef_H2O2">34</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 13,
    '207|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 13,
    '207,H,68,68');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 13,
    '207,O,68,64');

-- Test case 14, Cannot balance - Many complex PA ions
-- Reaction: Al + NO3 + HCl + U7 + Cl2 + S8 = Al(NO3)2 + H2O + (NO4)7(U2H)8(Cl5H6S4)50
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 14,
    '<span class="cpd_Al"> <span class="coef_Al"></span><span class="eall_Al erx_Al">Al</span></span> +  <span class="cpd_NO3"> <span class="coef_NO3"></span><span class="eall_N erx_N">N</span><span class="eall_O erx_O">O<sub>3</sub></span></span> +  <span class="cpd_HCl"> <span class="coef_HCl"></span><span class="eall_H erx_H">H</span><span class="eall_Cl erx_Cl">Cl</span></span> +  <span class="cpd_U7"> <span class="coef_U7"></span><span class="eall_U erx_U">U<sub>7</sub></span></span> +  <span class="cpd_Cl2"> <span class="coef_Cl2"></span><span class="eall_Cl erx_Cl">Cl<sub>2</sub></span></span> +  <span class="cpd_S8"> <span class="coef_S8"></span><span class="eall_S erx_S">S<sub>8</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_Al-NO3-2"> <span class="coef_Al-NO3-2"></span><span class="eall_Al epd_Al">Al</span>(<span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span>)<sub>2</sub></span> +  <span class="cpd_H2O"> <span class="coef_H2O"></span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span> +  <span class="cpd_-NO4-7-U2H-8-Cl5H6S4-50"> <span class="coef_-NO4-7-U2H-8-Cl5H6S4-50"></span>(<span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>4</sub></span>)<sub>7</sub>(<span class="eall_U epd_U">U<sub>2</sub></span><span class="eall_H epd_H">H</span>)<sub>8</sub>(<span class="eall_Cl epd_Cl">Cl<sub>5</sub></span><span class="eall_H epd_H">H<sub>6</sub></span><span class="eall_S epd_S">S<sub>4</sub></span>)<sub>50</sub></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 14,
    '1|** HARD OR IMPOSSIBLE to balance by inspection. Use the algebraic method or half-cell reactions instead');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '2|Consider compounds with element(s)  <span class="eall_N">N</span>, <span class="eall_Cl">Cl</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '3|Try to balance <span class="erx_Cl">Cl</span>\'s by multiplying reactants\' coefficients by 250');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '4|new <span class="cpd_HCl">HCl</span> coefficient is  <span class="coef_HCl">250</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '5|new <span class="cpd_Cl2">Cl2</span> coefficient is  <span class="coef_Cl2">250</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '6|Try to balance <span class="epd_Cl">Cl</span>\'s by multiplying products\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '7|new <span class="cpd_-NO4-7-U2H-8-Cl5H6S4-50">(NO4)7(U2H)8(Cl5H6S4)50</span> coefficient is  <span class="coef_-NO4-7-U2H-8-Cl5H6S4-50">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '8|Consider compounds with element(s)  <span class="eall_N">N</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '9|Find difference in product count and reaction count of <span class="eall_N">N</span>. It is 22');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '10|Check compounds only with <span class="erx_N">N</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '11|Inspect reactants to see if compounds with N can be adjusted to balance N');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '12|Check if the total <span class="erx_N">N</span> count on reactant side is a &gt\;1 factor of 22, the difference in <span class="erx_N">N</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '13|22 is exactly 22 times larger than the reactant <span class="erx_N">N</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '14|Increase coefficients by 22');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '15|new <span class="cpd_NO3">NO3</span> coefficient is  <span class="coef_NO3">23</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '16|Consider compounds with element(s)  <span class="eall_U">U</span>, <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '17|Find difference in product count and reaction count of <span class="eall_U">U</span>. It is 41');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '18|Check compounds only with <span class="erx_U">U</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '19|Inspect reactants to see if compounds with U can be adjusted to balance U');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '20|Check if the total <span class="erx_U">U</span> count on reactant side is a &gt\;1 factor of 41, the difference in <span class="erx_U">U</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '21|Total <span class="erx_U">U</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '22|Check compounds with <span class="erx_U">U</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '23|Try to balance <span class="erx_U">U</span>\'s by multiplying reactants\' coefficients by 48');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '24|new <span class="cpd_U7">U7</span> coefficient is  <span class="coef_U7">48</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '25|Consider compounds with element(s)  <span class="eall_U">U</span>, <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '26|Find difference in product count and reaction count of <span class="eall_U">U</span>. It is 288');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '27|Check compounds only with <span class="epd_U">U</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '28|Inspect products to see if compounds with U can be adjusted to balance U');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '29|No candidates found for U');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '30|Total <span class="epd_U">U</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '31|Check compounds with <span class="epd_U">U</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '32|Try to balance <span class="epd_U">U</span>\'s by multiplying products\' coefficients by 21');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '33|new <span class="cpd_-NO4-7-U2H-8-Cl5H6S4-50">(NO4)7(U2H)8(Cl5H6S4)50</span> coefficient is  <span class="coef_-NO4-7-U2H-8-Cl5H6S4-50">21</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '34|Consider compounds with element(s)  <span class="eall_N">N</span>, <span class="eall_Cl">Cl</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '35|Find difference in product count and reaction count of <span class="eall_N">N</span>. It is 126');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '36|Check compounds only with <span class="erx_N">N</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '37|Inspect reactants to see if compounds with N can be adjusted to balance N');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '38|Check if the total <span class="erx_N">N</span> count on reactant side is a &gt\;1 factor of 126, the difference in <span class="erx_N">N</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '39|126 is exactly 126 times larger than the reactant <span class="erx_N">N</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '40|Increase coefficients by 126');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '41|new <span class="cpd_NO3">NO3</span> coefficient is  <span class="coef_NO3">149</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '42|Consider compounds with element(s)  <span class="eall_Cl">Cl</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '43|Find difference in product count and reaction count of <span class="eall_Cl">Cl</span>. It is 4500');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '44|Check compounds only with <span class="erx_Cl">Cl</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '45|Inspect reactants to see if compounds with Cl can be adjusted to balance Cl');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '46|Check if the total <span class="erx_Cl">Cl</span> count on reactant side is a &gt\;1 factor of 4500, the difference in <span class="erx_Cl">Cl</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '47|4500 is exactly 1500 times larger than the reactant <span class="erx_Cl">Cl</span> count, 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '48|Increase coefficients by 1500');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '49|new <span class="cpd_HCl">HCl</span> coefficient is  <span class="coef_HCl">1750</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '50|new <span class="cpd_Cl2">Cl2</span> coefficient is  <span class="coef_Cl2">1750</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '51|Consider compounds with element(s)  <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '52|Find difference in product count and reaction count of <span class="eall_S">S</span>. It is 4192');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '53|Check compounds only with <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '54|Inspect reactants to see if compounds with S can be adjusted to balance S');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '55|Check if the total <span class="erx_S">S</span> count on reactant side is a &gt\;1 factor of 4192, the difference in <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '56|4192 is exactly 524 times larger than the reactant <span class="erx_S">S</span> count, 8');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '57|Increase coefficients by 524');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '58|new <span class="cpd_S8">S8</span> coefficient is  <span class="coef_S8">525</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '59|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '60|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 148');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '61|Check compounds only with <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '62|Inspect reactants to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '63|No candidates found for O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '64|Total <span class="erx_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '65|Check compounds with <span class="erx_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 14,
    '66|HARD OR IMPOSSIBLE to balance by inspection. Use the algebraic method or half-cell reactions instead');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 14,
    '66,Al,1,1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 14,
    '66,N,149,149');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 14,
    '66,O,447,595');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 14,
    '66,Cl,5250,5250');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 14,
    '66,H,1750,6470');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 14,
    '66,U,336,336');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 14,
    '66,S,4200,4200');

-- Test case 15, Cannot balance - a few PA ions
-- Reaction: K4Fe(CN)6 + KMnO4 + H2SO4 = KHSO4 + Fe2(SO4)3 + MnSO4 + HNO3 + CO2 + H2O
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 15,
    '<span class="cpd_K4Fe-CN-6"> <span class="coef_K4Fe-CN-6"></span><span class="eall_K erx_K">K<sub>4</sub></span><span class="eall_Fe erx_Fe">Fe</span>(<span class="eall_C erx_C">C</span><span class="eall_N erx_N">N</span>)<sub>6</sub></span> +  <span class="cpd_KMnO4"> <span class="coef_KMnO4"></span><span class="eall_K erx_K">K</span><span class="eall_Mn erx_Mn">Mn</span><span class="eall_O erx_O">O<sub>4</sub></span></span> +  <span class="cpd_H2SO4"> <span class="coef_H2SO4"></span><span class="eall_H erx_H">H<sub>2</sub></span><span class="eall_S erx_S">S</span><span class="eall_O erx_O">O<sub>4</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_KHSO4"> <span class="coef_KHSO4"></span><span class="eall_K epd_K">K</span><span class="eall_H epd_H">H</span><span class="eall_S epd_S">S</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_Fe2-SO4-3"> <span class="coef_Fe2-SO4-3"></span><span class="eall_Fe epd_Fe">Fe<sub>2</sub></span>(<span class="eall_S epd_S">S</span><span class="eall_O epd_O">O<sub>4</sub></span>)<sub>3</sub></span> +  <span class="cpd_MnSO4"> <span class="coef_MnSO4"></span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_S epd_S">S</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_HNO3"> <span class="coef_HNO3"></span><span class="eall_H epd_H">H</span><span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span></span> +  <span class="cpd_CO2"> <span class="coef_CO2"></span><span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>2</sub></span></span> +  <span class="cpd_H2O"> <span class="coef_H2O"></span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 15,
    '1|** HARD OR IMPOSSIBLE to balance by inspection. Use the algebraic method or half-cell reactions instead');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '2|Consider compounds with element(s)  <span class="eall_K">K</span>, <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '3|Try to balance <span class="epd_K">K</span>\'s by multiplying products\' coefficients by 5');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '4|new <span class="cpd_KHSO4">KHSO4</span> coefficient is  <span class="coef_KHSO4">5</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '5|Consider compounds with element(s)  <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '6|Find difference in product count and reaction count of <span class="eall_S">S</span>. It is 8');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '7|Check compounds only with <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '8|Inspect reactants to see if compounds with S can be adjusted to balance S');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '9|Check if the total <span class="erx_S">S</span> count on reactant side is a &gt\;1 factor of 8, the difference in <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '10|8 is exactly 8 times larger than the reactant <span class="erx_S">S</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '11|Increase coefficients by 8');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '12|new <span class="cpd_H2SO4">H2SO4</span> coefficient is  <span class="coef_H2SO4">9</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '13|Consider compounds with element(s)  <span class="eall_C">C</span>, <span class="eall_Fe">Fe</span>, <span class="eall_N">N</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '14|Find difference in product count and reaction count of <span class="eall_C">C</span>. It is 5');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '15|Check compounds only with <span class="epd_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '16|Inspect products to see if compounds with C can be adjusted to balance C');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '17|Check if the total <span class="epd_C">C</span> count on product side is a &gt\;1 factor of 5, the difference in <span class="epd_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '18|5 is exactly 5 times larger than the product <span class="epd_C">C</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '19|Increase coefficients by 5');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '20|new <span class="cpd_CO2">CO2</span> coefficient is  <span class="coef_CO2">6</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '21|Consider compounds with element(s)  <span class="eall_Fe">Fe</span>, <span class="eall_N">N</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '22|Find difference in product count and reaction count of <span class="eall_Fe">Fe</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '23|Check compounds only with <span class="erx_Fe">Fe</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '24|Inspect reactants to see if compounds with Fe can be adjusted to balance Fe');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '25|No candidates found for Fe');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '26|Total <span class="erx_Fe">Fe</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '27|Check compounds with <span class="erx_Fe">Fe</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '28|Try to balance <span class="erx_Fe">Fe</span>\'s by multiplying reactants\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '29|new <span class="cpd_K4Fe-CN-6">K4Fe(CN)6</span> coefficient is  <span class="coef_K4Fe-CN-6">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '30|Consider compounds with element(s)  <span class="eall_K">K</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '31|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '32|Check compounds only with <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '33|Inspect products to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '34|No candidates found for K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '35|Total <span class="epd_K">K</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '36|Check compounds with <span class="epd_K">K</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '37|Try to balance <span class="epd_K">K</span>\'s by multiplying products\' coefficients by 45');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '38|new <span class="cpd_KHSO4">KHSO4</span> coefficient is  <span class="coef_KHSO4">45</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '39|Consider compounds with element(s)  <span class="eall_K">K</span>, <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '40|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 36');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '41|Check compounds only with <span class="erx_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '42|Inspect reactants to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '43|No candidates found for K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '44|Total <span class="erx_K">K</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '45|Check compounds with <span class="erx_K">K</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '46|Balance using <span class="erx_K">K</span>4Fe(CN)6, which has a <span class="erx_K">K</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '47|Balance using <span class="erx_K">K</span>MnO4, which has a <span class="erx_K">K</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '48|Re-balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '49|Re-balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '50|Re-balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '51|Re-balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '52|Balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '53|Balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '54|Balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '55|Balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '56|Balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '57|Balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '58|Balance by changing coefficients of <span class="erx_K">K</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '59|new <span class="cpd_K4Fe-CN-6">K4Fe(CN)6</span> coefficient is  <span class="coef_K4Fe-CN-6">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '60|new <span class="cpd_KMnO4">KMnO4</span> coefficient is  <span class="coef_KMnO4">33</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '61|Consider compounds with element(s)  <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '62|Find difference in product count and reaction count of <span class="eall_S">S</span>. It is 40');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '63|Check compounds only with <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '64|Inspect reactants to see if compounds with S can be adjusted to balance S');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '65|Check if the total <span class="erx_S">S</span> count on reactant side is a &gt\;1 factor of 40, the difference in <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '66|40 is exactly 40 times larger than the reactant <span class="erx_S">S</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '67|Increase coefficients by 40');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '68|new <span class="cpd_H2SO4">H2SO4</span> coefficient is  <span class="coef_H2SO4">49</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '69|Consider compounds with element(s)  <span class="eall_C">C</span>, <span class="eall_Fe">Fe</span>, <span class="eall_N">N</span>, <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '70|Find difference in product count and reaction count of <span class="eall_Fe">Fe</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '71|Check compounds only with <span class="epd_Fe">Fe</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '72|Inspect products to see if compounds with Fe can be adjusted to balance Fe');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '73|No candidates found for Fe');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '74|Total <span class="epd_Fe">Fe</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '75|Check compounds with <span class="epd_Fe">Fe</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '76|Try to balance <span class="epd_Fe">Fe</span>\'s by multiplying products\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '77|new <span class="cpd_Fe2-SO4-3">Fe2(SO4)3</span> coefficient is  <span class="coef_Fe2-SO4-3">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '78|Consider compounds with element(s)  <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '79|Find difference in product count and reaction count of <span class="eall_S">S</span>. It is 6');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '80|Check compounds only with <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '81|Inspect reactants to see if compounds with S can be adjusted to balance S');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '82|Check if the total <span class="erx_S">S</span> count on reactant side is a &gt\;1 factor of 6, the difference in <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '83|6 is exactly 6 times larger than the reactant <span class="erx_S">S</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '84|Increase coefficients by 6');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '85|new <span class="cpd_H2SO4">H2SO4</span> coefficient is  <span class="coef_H2SO4">55</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '86|Consider compounds with element(s)  <span class="eall_C">C</span>, <span class="eall_Fe">Fe</span>, <span class="eall_N">N</span>, <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '87|Find difference in product count and reaction count of <span class="eall_Fe">Fe</span>. It is 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '88|Check compounds only with <span class="erx_Fe">Fe</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '89|Inspect reactants to see if compounds with Fe can be adjusted to balance Fe');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '90|No candidates found for Fe');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '91|Total <span class="erx_Fe">Fe</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '92|Check compounds with <span class="erx_Fe">Fe</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '93|Try to balance <span class="erx_Fe">Fe</span>\'s by multiplying reactants\' coefficients by 6');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '94|new <span class="cpd_K4Fe-CN-6">K4Fe(CN)6</span> coefficient is  <span class="coef_K4Fe-CN-6">6</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '95|Consider compounds with element(s)  <span class="eall_K">K</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '96|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 12');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '97|Check compounds only with <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '98|Inspect products to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '99|No candidates found for K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '100|Total <span class="epd_K">K</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '101|Check compounds with <span class="epd_K">K</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '102|Try to balance <span class="epd_K">K</span>\'s by multiplying products\' coefficients by 855');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '103|new <span class="cpd_KHSO4">KHSO4</span> coefficient is  <span class="coef_KHSO4">855</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '104|Consider compounds with element(s)  <span class="eall_K">K</span>, <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '105|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 798');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '106|Check compounds only with <span class="erx_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '107|Inspect reactants to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '108|Check if the total <span class="erx_K">K</span> count on reactant side is a &gt\;1 factor of 798, the difference in <span class="erx_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '109|798 is exactly 798 times larger than the reactant <span class="erx_K">K</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '110|Increase coefficients by 798');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '111|new <span class="cpd_KMnO4">KMnO4</span> coefficient is  <span class="coef_KMnO4">831</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '112|Consider compounds with element(s)  <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '113|Find difference in product count and reaction count of <span class="eall_S">S</span>. It is 810');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '114|Check compounds only with <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '115|Inspect reactants to see if compounds with S can be adjusted to balance S');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '116|Check if the total <span class="erx_S">S</span> count on reactant side is a &gt\;1 factor of 810, the difference in <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '117|810 is exactly 810 times larger than the reactant <span class="erx_S">S</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '118|Increase coefficients by 810');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '119|new <span class="cpd_H2SO4">H2SO4</span> coefficient is  <span class="coef_H2SO4">865</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '120|Consider compounds with element(s)  <span class="eall_C">C</span>, <span class="eall_N">N</span>, <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '121|Find difference in product count and reaction count of <span class="eall_C">C</span>. It is 30');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '122|Check compounds only with <span class="epd_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '123|Inspect products to see if compounds with C can be adjusted to balance C');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '124|Check if the total <span class="epd_C">C</span> count on product side is a &gt\;1 factor of 30, the difference in <span class="epd_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '125|30 is exactly 30 times larger than the product <span class="epd_C">C</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '126|Increase coefficients by 30');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '127|new <span class="cpd_CO2">CO2</span> coefficient is  <span class="coef_CO2">36</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '128|Consider compounds with element(s)  <span class="eall_N">N</span>, <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '129|Find difference in product count and reaction count of <span class="eall_N">N</span>. It is 35');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '130|Check compounds only with <span class="epd_N">N</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '131|Inspect products to see if compounds with N can be adjusted to balance N');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '132|Check if the total <span class="epd_N">N</span> count on product side is a &gt\;1 factor of 35, the difference in <span class="epd_N">N</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '133|35 is exactly 35 times larger than the product <span class="epd_N">N</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '134|Increase coefficients by 35');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '135|new <span class="cpd_HNO3">HNO3</span> coefficient is  <span class="coef_HNO3">36</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '136|Consider compounds with element(s)  <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '137|Find difference in product count and reaction count of <span class="eall_Mn">Mn</span>. It is 830');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '138|Check compounds only with <span class="epd_Mn">Mn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '139|Inspect products to see if compounds with Mn can be adjusted to balance Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '140|No candidates found for Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '141|Total <span class="epd_Mn">Mn</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '142|Check compounds with <span class="epd_Mn">Mn</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '143|Try to balance <span class="epd_Mn">Mn</span>\'s by multiplying products\' coefficients by 831');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '144|new <span class="cpd_MnSO4">MnSO4</span> coefficient is  <span class="coef_MnSO4">831</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '145|Consider compounds with element(s)  <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '146|Find difference in product count and reaction count of <span class="eall_S">S</span>. It is 830');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '147|Check compounds only with <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '148|Inspect reactants to see if compounds with S can be adjusted to balance S');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '149|Check if the total <span class="erx_S">S</span> count on reactant side is a &gt\;1 factor of 830, the difference in <span class="erx_S">S</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '150|830 is exactly 830 times larger than the reactant <span class="erx_S">S</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '151|Increase coefficients by 830');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '152|new <span class="cpd_H2SO4">H2SO4</span> coefficient is  <span class="coef_H2SO4">1695</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '153|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '154|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 2497');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '155|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '156|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '157|Check if the total <span class="epd_H">H</span> count on product side is a &gt\;1 factor of 2497, the difference in <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '158|Total <span class="epd_H">H</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '159|Check compounds with <span class="epd_H">H</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '160|Balance using <span class="cpd_KHSO4">KHSO4</span>, which has a <span class="epd_H">H</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '161|Balance using <span class="epd_H">H</span>NO3, which has a <span class="epd_H">H</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '162|Balance using <span class="epd_H">H</span>2O, which has a <span class="epd_H">H</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '163|new <span class="cpd_KHSO4">KHSO4</span> coefficient is  <span class="coef_KHSO4">2497</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '164|new <span class="cpd_HNO3">HNO3</span> coefficient is  <span class="coef_HNO3">2497</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '165|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">2499</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '166|Consider compounds with element(s)  <span class="eall_K">K</span>, <span class="eall_S">S</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '167|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 1642');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '168|Check compounds only with <span class="erx_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '169|Inspect reactants to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '170|No candidates found for K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '171|Total <span class="erx_K">K</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '172|Check compounds with <span class="erx_K">K</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '173|Balance using <span class="erx_K">K</span>4Fe(CN)6, which has a <span class="erx_K">K</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '174|Balance using <span class="erx_K">K</span>MnO4, which has a <span class="erx_K">K</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 15,
    '175|HARD OR IMPOSSIBLE to balance by inspection. Use the algebraic method or half-cell reactions instead');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 15,
    '175,C,36,36');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 15,
    '175,Fe,6,6');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 15,
    '175,K,855,2497');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 15,
    '175,N,36,2497');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 15,
    '175,Mn,831,831');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 15,
    '175,O,10104,23410');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 15,
    '175,H,3390,9992');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 15,
    '175,S,1695,3337');

-- Test case 16, Cannot balance - one PA ion
-- Reaction: K2MnO4 + Cl2 = KMnO4 + KCl
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 16,
    '<span class="cpd_K2MnO4"> <span class="coef_K2MnO4"></span><span class="eall_K erx_K">K<sub>2</sub></span><span class="eall_Mn erx_Mn">Mn</span><span class="eall_O erx_O">O<sub>4</sub></span></span> +  <span class="cpd_Cl2"> <span class="coef_Cl2"></span><span class="eall_Cl erx_Cl">Cl<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_KMnO4"> <span class="coef_KMnO4"></span><span class="eall_K epd_K">K</span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_KCl"> <span class="coef_KCl"></span><span class="eall_K epd_K">K</span><span class="eall_Cl epd_Cl">Cl</span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 16,
    '1|** HARD OR IMPOSSIBLE to balance by inspection. Use the algebraic method or half-cell reactions instead');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '2|Consider compounds with element(s)  <span class="eall_Cl">Cl</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '3|Try to balance <span class="epd_Cl">Cl</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '4|new <span class="cpd_KCl">KCl</span> coefficient is  <span class="coef_KCl">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '5|Consider compounds with element(s)  <span class="eall_K">K</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '6|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '7|Check compounds only with <span class="erx_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '8|Inspect reactants to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '9|No candidates found for K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '10|Total <span class="erx_K">K</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '11|Check compounds with <span class="erx_K">K</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '12|Try to balance <span class="erx_K">K</span>\'s by multiplying reactants\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '13|new <span class="cpd_K2MnO4">K2MnO4</span> coefficient is  <span class="coef_K2MnO4">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '14|Consider compounds with element(s)  <span class="eall_K">K</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '15|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '16|Check compounds only with <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '17|Inspect products to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '18|Check if the total <span class="epd_K">K</span> count on product side is a &gt\;1 factor of 3, the difference in <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '19|3 is exactly 3 times larger than the product <span class="epd_K">K</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '20|Increase coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '21|new <span class="cpd_KMnO4">KMnO4</span> coefficient is  <span class="coef_KMnO4">4</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '22|Consider compounds with element(s)  <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '23|Find difference in product count and reaction count of <span class="eall_Mn">Mn</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '24|Check compounds only with <span class="erx_Mn">Mn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '25|Inspect reactants to see if compounds with Mn can be adjusted to balance Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '26|No candidates found for Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '27|Total <span class="erx_Mn">Mn</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '28|Check compounds with <span class="erx_Mn">Mn</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '29|Try to balance <span class="erx_Mn">Mn</span>\'s by multiplying reactants\' coefficients by 12');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '30|new <span class="cpd_K2MnO4">K2MnO4</span> coefficient is  <span class="coef_K2MnO4">12</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '31|Consider compounds with element(s)  <span class="eall_K">K</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '32|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 18');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '33|Check compounds only with <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '34|Inspect products to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '35|Check if the total <span class="epd_K">K</span> count on product side is a &gt\;1 factor of 18, the difference in <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '36|18 is exactly 18 times larger than the product <span class="epd_K">K</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '37|Increase coefficients by 18');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '38|new <span class="cpd_KMnO4">KMnO4</span> coefficient is  <span class="coef_KMnO4">22</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '39|Consider compounds with element(s)  <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '40|Find difference in product count and reaction count of <span class="eall_Mn">Mn</span>. It is 10');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '41|Check compounds only with <span class="erx_Mn">Mn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '42|Inspect reactants to see if compounds with Mn can be adjusted to balance Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '43|No candidates found for Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '44|Total <span class="erx_Mn">Mn</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '45|Check compounds with <span class="erx_Mn">Mn</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '46|Try to balance <span class="erx_Mn">Mn</span>\'s by multiplying reactants\' coefficients by 132');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '47|new <span class="cpd_K2MnO4">K2MnO4</span> coefficient is  <span class="coef_K2MnO4">132</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '48|Consider compounds with element(s)  <span class="eall_K">K</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '49|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 240');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '50|Check compounds only with <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '51|Inspect products to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '52|Check if the total <span class="epd_K">K</span> count on product side is a &gt\;1 factor of 240, the difference in <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '53|240 is exactly 240 times larger than the product <span class="epd_K">K</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '54|Increase coefficients by 240');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '55|new <span class="cpd_KMnO4">KMnO4</span> coefficient is  <span class="coef_KMnO4">262</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '56|Consider compounds with element(s)  <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '57|Find difference in product count and reaction count of <span class="eall_Mn">Mn</span>. It is 130');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '58|Check compounds only with <span class="erx_Mn">Mn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '59|Inspect reactants to see if compounds with Mn can be adjusted to balance Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '60|No candidates found for Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '61|Total <span class="erx_Mn">Mn</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '62|Check compounds with <span class="erx_Mn">Mn</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '63|Try to balance <span class="erx_Mn">Mn</span>\'s by multiplying reactants\' coefficients by 17292');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '64|new <span class="cpd_K2MnO4">K2MnO4</span> coefficient is  <span class="coef_K2MnO4">17292</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '65|Consider compounds with element(s)  <span class="eall_K">K</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '66|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 34320');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '67|Check compounds only with <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '68|Inspect products to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '69|Check if the total <span class="epd_K">K</span> count on product side is a &gt\;1 factor of 34320, the difference in <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '70|34320 is exactly 34320 times larger than the product <span class="epd_K">K</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '71|Increase coefficients by 34320');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '72|new <span class="cpd_KMnO4">KMnO4</span> coefficient is  <span class="coef_KMnO4">34582</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '73|Consider compounds with element(s)  <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '74|Find difference in product count and reaction count of <span class="eall_Mn">Mn</span>. It is 17290');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '75|Check compounds only with <span class="erx_Mn">Mn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '76|Inspect reactants to see if compounds with Mn can be adjusted to balance Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '77|No candidates found for Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '78|Total <span class="erx_Mn">Mn</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '79|Check compounds with <span class="erx_Mn">Mn</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (2, 16,
    '80|HARD OR IMPOSSIBLE to balance by inspection. Use the algebraic method or half-cell reactions instead');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 16,
    '80,K,34584,34584');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 16,
    '80,Mn,17292,34582');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 16,
    '80,O,69168,138328');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 16,
    '80,Cl,2,2');

-- Test case 17, Warning - last term after "=" ignored
-- Reaction: K2MnO4 + CO2 = KMnO4 + K2CO3 + MnO2 = PO
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 17,
    '<span class="cpd_K2MnO4"> <span class="coef_K2MnO4"></span><span class="eall_K erx_K">K<sub>2</sub></span><span class="eall_Mn erx_Mn">Mn</span><span class="eall_O erx_O">O<sub>4</sub></span></span> +  <span class="cpd_CO2"> <span class="coef_CO2"></span><span class="eall_C erx_C">C</span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_KMnO4"> <span class="coef_KMnO4"></span><span class="eall_K epd_K">K</span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_K2CO3"> <span class="coef_K2CO3"></span><span class="eall_K epd_K">K<sub>2</sub></span><span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>3</sub></span></span> +  <span class="cpd_MnO2"> <span class="coef_MnO2"></span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>2</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 17,
    '<span class="cpd_K2MnO4"> <span class="coef_K2MnO4">3</span><span class="eall_K erx_K">K<sub>2</sub></span><span class="eall_Mn erx_Mn">Mn</span><span class="eall_O erx_O">O<sub>4</sub></span></span> +  <span class="cpd_CO2"> <span class="coef_CO2">2</span><span class="eall_C erx_C">C</span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_KMnO4"> <span class="coef_KMnO4">2</span><span class="eall_K epd_K">K</span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_K2CO3"> <span class="coef_K2CO3">2</span><span class="eall_K epd_K">K<sub>2</sub></span><span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>3</sub></span></span> +  <span class="cpd_MnO2"> <span class="coef_MnO2"></span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>2</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (4, 17,
    'Too many =\'s!! All characters after the second \'=\' have been ignored.');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '1|Consider compounds with element(s)  <span class="eall_K">K</span>, <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '2|Try to balance <span class="erx_K">K</span>\'s by multiplying reactants\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '3|new <span class="cpd_K2MnO4">K2MnO4</span> coefficient is  <span class="coef_K2MnO4">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '4|Try to balance <span class="epd_K">K</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '5|new <span class="cpd_KMnO4">KMnO4</span> coefficient is  <span class="coef_KMnO4">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '6|new <span class="cpd_K2CO3">K2CO3</span> coefficient is  <span class="coef_K2CO3">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '7|Consider compounds with element(s)  <span class="eall_C">C</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '8|Find difference in product count and reaction count of <span class="eall_C">C</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '9|Check compounds only with <span class="erx_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '10|Inspect reactants to see if compounds with C can be adjusted to balance C');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '11|Check if the total <span class="erx_C">C</span> count on reactant side is a &gt\;1 factor of 1, the difference in <span class="erx_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '12|1 is exactly 1 times larger than the reactant <span class="erx_C">C</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '13|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 17,
    '14|new <span class="cpd_CO2">CO2</span> coefficient is  <span class="coef_CO2">2</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 17,
    '14,K,6,6');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 17,
    '14,Mn,3,3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 17,
    '14,O,16,16');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 17,
    '14,C,2,2');

-- Test case 18, Anion and cation with same element
-- Reaction: NaNO3 + NH4OH = NaH + NH4NO3 + HNO3
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 18,
    '<span class="cpd_NaNO3"> <span class="coef_NaNO3"></span><span class="eall_Na erx_Na">Na</span><span class="eall_N erx_N">N</span><span class="eall_O erx_O">O<sub>3</sub></span></span> +  <span class="cpd_NH4OH"> <span class="coef_NH4OH"></span><span class="eall_N erx_N">N</span><span class="eall_H erx_H">H<sub>4</sub></span><span class="eall_O erx_O">O</span><span class="eall_H erx_H">H</span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_NaH"> <span class="coef_NaH"></span><span class="eall_Na epd_Na">Na</span><span class="eall_H epd_H">H</span></span> +  <span class="cpd_NH4NO3"> <span class="coef_NH4NO3"></span><span class="eall_N epd_N">N</span><span class="eall_H epd_H">H<sub>4</sub></span><span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span></span> +  <span class="cpd_HNO3"> <span class="coef_HNO3"></span><span class="eall_H epd_H">H</span><span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 18,
    '<span class="cpd_NaNO3"> <span class="coef_NaNO3">4</span><span class="eall_Na erx_Na">Na</span><span class="eall_N erx_N">N</span><span class="eall_O erx_O">O<sub>3</sub></span></span> +  <span class="cpd_NH4OH"> <span class="coef_NH4OH">3</span><span class="eall_N erx_N">N</span><span class="eall_H erx_H">H<sub>4</sub></span><span class="eall_O erx_O">O</span><span class="eall_H erx_H">H</span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_NaH"> <span class="coef_NaH">4</span><span class="eall_Na epd_Na">Na</span><span class="eall_H epd_H">H</span></span> +  <span class="cpd_NH4NO3"> <span class="coef_NH4NO3">2</span><span class="eall_N epd_N">N</span><span class="eall_H epd_H">H<sub>4</sub></span><span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span></span> +  <span class="cpd_HNO3"> <span class="coef_HNO3">3</span><span class="eall_H epd_H">H</span><span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '1|Consider compounds with element(s)  <span class="eall_N">N</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '2|Try to balance <span class="erx_N">N</span>\'s by multiplying reactants\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '3|new <span class="cpd_NaNO3">NaNO3</span> coefficient is  <span class="coef_NaNO3">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '4|new <span class="cpd_NH4OH">NH4OH</span> coefficient is  <span class="coef_NH4OH">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '5|Try to balance <span class="epd_N">N</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '6|new <span class="cpd_NH4NO3">NH4NO3</span> coefficient is  <span class="coef_NH4NO3">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '7|new <span class="cpd_HNO3">HNO3</span> coefficient is  <span class="coef_HNO3">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '8|Consider compounds with element(s)  <span class="eall_Na">Na</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '9|Find difference in product count and reaction count of <span class="eall_Na">Na</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '10|Check compounds only with <span class="epd_Na">Na</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '11|Inspect products to see if compounds with Na can be adjusted to balance Na');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '12|Check if the total <span class="epd_Na">Na</span> count on product side is a &gt\;1 factor of 2, the difference in <span class="epd_Na">Na</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '13|2 is exactly 2 times larger than the product <span class="epd_Na">Na</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '14|Increase coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '15|new <span class="cpd_NaH">NaH</span> coefficient is  <span class="coef_NaH">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '16|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '17|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '18|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '19|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '20|No candidates found for H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '21|Total <span class="epd_H">H</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '22|Check compounds with <span class="epd_H">H</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '23|Balance using <span class="cpd_NaH">NaH</span>, which has a <span class="epd_H">H</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '24|Balance using <span class="epd_H">H</span>NO3, which has a <span class="epd_H">H</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '25|Re-balance by changing coefficients of <span class="epd_H">H</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '26|new <span class="cpd_NaH">NaH</span> coefficient is  <span class="coef_NaH">4</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '27|new <span class="cpd_HNO3">HNO3</span> coefficient is  <span class="coef_HNO3">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '28|Consider compounds with element(s)  <span class="eall_Na">Na</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '29|Find difference in product count and reaction count of <span class="eall_Na">Na</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '30|Check compounds only with <span class="erx_Na">Na</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '31|Inspect reactants to see if compounds with Na can be adjusted to balance Na');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '32|Check if the total <span class="erx_Na">Na</span> count on reactant side is a &gt\;1 factor of 1, the difference in <span class="erx_Na">Na</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '33|1 is exactly 1 times larger than the reactant <span class="erx_Na">Na</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '34|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 18,
    '35|new <span class="cpd_NaNO3">NaNO3</span> coefficient is  <span class="coef_NaNO3">4</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 18,
    '35,N,7,7');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 18,
    '35,Na,4,4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 18,
    '35,O,15,15');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 18,
    '35,H,15,15');

-- Test case 19, Anion and cation with same element, reactants in reverse order
-- Reaction: NH4OH + NaNO3 = NaH + NH4NO3 + HNO3
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 19,
    '<span class="cpd_NH4OH"> <span class="coef_NH4OH"></span><span class="eall_N erx_N">N</span><span class="eall_H erx_H">H<sub>4</sub></span><span class="eall_O erx_O">O</span><span class="eall_H erx_H">H</span></span> +  <span class="cpd_NaNO3"> <span class="coef_NaNO3"></span><span class="eall_Na erx_Na">Na</span><span class="eall_N erx_N">N</span><span class="eall_O erx_O">O<sub>3</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_NaH"> <span class="coef_NaH"></span><span class="eall_Na epd_Na">Na</span><span class="eall_H epd_H">H</span></span> +  <span class="cpd_NH4NO3"> <span class="coef_NH4NO3"></span><span class="eall_N epd_N">N</span><span class="eall_H epd_H">H<sub>4</sub></span><span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span></span> +  <span class="cpd_HNO3"> <span class="coef_HNO3"></span><span class="eall_H epd_H">H</span><span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 19,
    '<span class="cpd_NH4OH"> <span class="coef_NH4OH">3</span><span class="eall_N erx_N">N</span><span class="eall_H erx_H">H<sub>4</sub></span><span class="eall_O erx_O">O</span><span class="eall_H erx_H">H</span></span> +  <span class="cpd_NaNO3"> <span class="coef_NaNO3">4</span><span class="eall_Na erx_Na">Na</span><span class="eall_N erx_N">N</span><span class="eall_O erx_O">O<sub>3</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_NaH"> <span class="coef_NaH">4</span><span class="eall_Na epd_Na">Na</span><span class="eall_H epd_H">H</span></span> +  <span class="cpd_NH4NO3"> <span class="coef_NH4NO3">2</span><span class="eall_N epd_N">N</span><span class="eall_H epd_H">H<sub>4</sub></span><span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span></span> +  <span class="cpd_HNO3"> <span class="coef_HNO3">3</span><span class="eall_H epd_H">H</span><span class="eall_N epd_N">N</span><span class="eall_O epd_O">O<sub>3</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '1|Consider compounds with element(s)  <span class="eall_N">N</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '2|Try to balance <span class="erx_N">N</span>\'s by multiplying reactants\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '3|new <span class="cpd_NH4OH">NH4OH</span> coefficient is  <span class="coef_NH4OH">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '4|new <span class="cpd_NaNO3">NaNO3</span> coefficient is  <span class="coef_NaNO3">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '5|Try to balance <span class="epd_N">N</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '6|new <span class="cpd_NH4NO3">NH4NO3</span> coefficient is  <span class="coef_NH4NO3">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '7|new <span class="cpd_HNO3">HNO3</span> coefficient is  <span class="coef_HNO3">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '8|Consider compounds with element(s)  <span class="eall_Na">Na</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '9|Find difference in product count and reaction count of <span class="eall_Na">Na</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '10|Check compounds only with <span class="epd_Na">Na</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '11|Inspect products to see if compounds with Na can be adjusted to balance Na');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '12|Check if the total <span class="epd_Na">Na</span> count on product side is a &gt\;1 factor of 2, the difference in <span class="epd_Na">Na</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '13|2 is exactly 2 times larger than the product <span class="epd_Na">Na</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '14|Increase coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '15|new <span class="cpd_NaH">NaH</span> coefficient is  <span class="coef_NaH">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '16|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '17|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '18|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '19|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '20|No candidates found for H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '21|Total <span class="epd_H">H</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '22|Check compounds with <span class="epd_H">H</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '23|Balance using <span class="cpd_NaH">NaH</span>, which has a <span class="epd_H">H</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '24|Balance using <span class="epd_H">H</span>NO3, which has a <span class="epd_H">H</span> count that is a factor of difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '25|Re-balance by changing coefficients of <span class="epd_H">H</span> compounds such that their atom count sum is a factor of the difference');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '26|new <span class="cpd_NaH">NaH</span> coefficient is  <span class="coef_NaH">4</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '27|new <span class="cpd_HNO3">HNO3</span> coefficient is  <span class="coef_HNO3">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '28|Consider compounds with element(s)  <span class="eall_Na">Na</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '29|Find difference in product count and reaction count of <span class="eall_Na">Na</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '30|Check compounds only with <span class="erx_Na">Na</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '31|Inspect reactants to see if compounds with Na can be adjusted to balance Na');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '32|Check if the total <span class="erx_Na">Na</span> count on reactant side is a &gt\;1 factor of 1, the difference in <span class="erx_Na">Na</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '33|1 is exactly 1 times larger than the reactant <span class="erx_Na">Na</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '34|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 19,
    '35|new <span class="cpd_NaNO3">NaNO3</span> coefficient is  <span class="coef_NaNO3">4</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 19,
    '35,H,15,15');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 19,
    '35,N,7,7');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 19,
    '35,O,15,15');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 19,
    '35,Na,4,4');

-- Test case 20, Balance with same PA ion on both sides of the equation, but with different counts
-- Reaction: (NH4)2CO3 + AlPO4 = (NH4)3PO4 + Al2(CO3)3
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 20,
    '<span class="cpd_-NH4-2CO3"> <span class="coef_-NH4-2CO3"></span>(<span class="eall_N erx_N">N</span><span class="eall_H erx_H">H<sub>4</sub></span>)<sub>2</sub><span class="eall_C erx_C">C</span><span class="eall_O erx_O">O<sub>3</sub></span></span> +  <span class="cpd_AlPO4"> <span class="coef_AlPO4"></span><span class="eall_Al erx_Al">Al</span><span class="eall_P erx_P">P</span><span class="eall_O erx_O">O<sub>4</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_-NH4-3PO4"> <span class="coef_-NH4-3PO4"></span>(<span class="eall_N epd_N">N</span><span class="eall_H epd_H">H<sub>4</sub></span>)<sub>3</sub><span class="eall_P epd_P">P</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_Al2-CO3-3"> <span class="coef_Al2-CO3-3"></span><span class="eall_Al epd_Al">Al<sub>2</sub></span>(<span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>3</sub></span>)<sub>3</sub></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 20,
    '<span class="cpd_-NH4-2CO3"> <span class="coef_-NH4-2CO3">3</span>(<span class="eall_N erx_N">N</span><span class="eall_H erx_H">H<sub>4</sub></span>)<sub>2</sub><span class="eall_C erx_C">C</span><span class="eall_O erx_O">O<sub>3</sub></span></span> +  <span class="cpd_AlPO4"> <span class="coef_AlPO4">2</span><span class="eall_Al erx_Al">Al</span><span class="eall_P erx_P">P</span><span class="eall_O erx_O">O<sub>4</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_-NH4-3PO4"> <span class="coef_-NH4-3PO4">2</span>(<span class="eall_N epd_N">N</span><span class="eall_H epd_H">H<sub>4</sub></span>)<sub>3</sub><span class="eall_P epd_P">P</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_Al2-CO3-3"> <span class="coef_Al2-CO3-3"></span><span class="eall_Al epd_Al">Al<sub>2</sub></span>(<span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>3</sub></span>)<sub>3</sub></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '1|Consider compounds with element(s)  <span class="eall_C">C</span>, <span class="eall_N">N</span>, <span class="eall_Al">Al</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '2|Try to balance <span class="erx_N">N</span>\'s by multiplying reactants\' coefficients by 3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '3|new <span class="cpd_-NH4-2CO3">(NH4)2CO3</span> coefficient is  <span class="coef_-NH4-2CO3">3</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '4|Try to balance <span class="epd_N">N</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '5|new <span class="cpd_-NH4-3PO4">(NH4)3PO4</span> coefficient is  <span class="coef_-NH4-3PO4">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '6|Consider compounds with element(s)  <span class="eall_Al">Al</span>, <span class="eall_P">P</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '7|Find difference in product count and reaction count of <span class="eall_Al">Al</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '8|Check compounds only with <span class="erx_Al">Al</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '9|Inspect reactants to see if compounds with Al can be adjusted to balance Al');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '10|Check if the total <span class="erx_Al">Al</span> count on reactant side is a &gt\;1 factor of 1, the difference in <span class="erx_Al">Al</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '11|1 is exactly 1 times larger than the reactant <span class="erx_Al">Al</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '12|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 20,
    '13|new <span class="cpd_AlPO4">AlPO4</span> coefficient is  <span class="coef_AlPO4">2</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 20,
    '13,C,3,3');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 20,
    '13,H,24,24');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 20,
    '13,N,6,6');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 20,
    '13,O,17,17');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 20,
    '13,Al,2,2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 20,
    '13,P,2,2');

-- Test case 21, Balanced but coefficients reduced at end
-- Reaction: C4H10 + O2 = CO2 + H2O
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 21,
    '<span class="cpd_C4H10"> <span class="coef_C4H10"></span><span class="eall_C erx_C">C<sub>4</sub></span><span class="eall_H erx_H">H<sub>10</sub></span></span> +  <span class="cpd_O2"> <span class="coef_O2"></span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_CO2"> <span class="coef_CO2"></span><span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>2</sub></span></span> +  <span class="cpd_H2O"> <span class="coef_H2O"></span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 21,
    '<span class="cpd_C4H10"> <span class="coef_C4H10">2</span><span class="eall_C erx_C">C<sub>4</sub></span><span class="eall_H erx_H">H<sub>10</sub></span></span> +  <span class="cpd_O2"> <span class="coef_O2">13</span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_CO2"> <span class="coef_CO2">8</span><span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>2</sub></span></span> +  <span class="cpd_H2O"> <span class="coef_H2O">10</span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '1|Consider compounds with element(s)  <span class="eall_C">C</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '2|Try to balance <span class="epd_C">C</span>\'s by multiplying products\' coefficients by 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '3|new <span class="cpd_CO2">CO2</span> coefficient is  <span class="coef_CO2">4</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '4|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '5|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 8');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '6|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '7|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '8|Check if the total <span class="epd_H">H</span> count on product side is a &gt\;1 factor of 8, the difference in <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '9|8 is exactly 4 times larger than the product <span class="epd_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '10|Increase coefficients by 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '11|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">5</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '12|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '13|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 11');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '14|Check compounds only with <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '15|Inspect reactants to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '16|Check if the total <span class="erx_O">O</span> count on reactant side is a &gt\;1 factor of 11, the difference in <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '17|Total <span class="erx_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '18|Check compounds with <span class="erx_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '19|Try to balance <span class="erx_O">O</span>\'s by multiplying reactants\' coefficients by 13');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '20|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">13</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '21|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '22|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 13');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '23|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '24|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '25|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 13, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '26|13 is exactly 13 times larger than the product <span class="epd_O">O</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '27|Increase coefficients by 13');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '28|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">18</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '29|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '30|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 26');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '31|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '32|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '33|No candidates found for H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '34|Total <span class="erx_H">H</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '35|Check compounds with <span class="erx_H">H</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '36|Try to balance <span class="erx_H">H</span>\'s by multiplying reactants\' coefficients by 18');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '37|new <span class="cpd_C4H10">C4H10</span> coefficient is  <span class="coef_C4H10">18</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '38|Consider compounds with element(s)  <span class="eall_C">C</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '39|Find difference in product count and reaction count of <span class="eall_C">C</span>. It is 68');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '40|Check compounds only with <span class="epd_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '41|Inspect products to see if compounds with C can be adjusted to balance C');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '42|Check if the total <span class="epd_C">C</span> count on product side is a &gt\;1 factor of 68, the difference in <span class="epd_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '43|68 is exactly 68 times larger than the product <span class="epd_C">C</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '44|Increase coefficients by 68');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '45|new <span class="cpd_CO2">CO2</span> coefficient is  <span class="coef_CO2">72</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '46|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '47|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 144');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '48|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '49|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '50|Check if the total <span class="epd_H">H</span> count on product side is a &gt\;1 factor of 144, the difference in <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '51|144 is exactly 72 times larger than the product <span class="epd_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '52|Increase coefficients by 72');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '53|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">90</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '54|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '55|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 208');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '56|Check compounds only with <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '57|Inspect reactants to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '58|Check if the total <span class="erx_O">O</span> count on reactant side is a &gt\;1 factor of 208, the difference in <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '59|208 is exactly 104 times larger than the reactant <span class="erx_O">O</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '60|Increase coefficients by 104');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '61|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">117</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '62|Coefficients reduced by common factor of 9');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 21,
    '63|A better coefficient sum could have been used during balancing to get the lowest possible integer coefficients.');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 21,
    '63,C,8,8');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 21,
    '63,H,20,20');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 21,
    '63,O,26,26');

-- Test case 22, Balanced but coefficients reduced at end - both sides reversed
-- Reaction: O2 + C4H10 = H2O + CO2
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 22,
    '<span class="cpd_O2"> <span class="coef_O2"></span><span class="eall_O erx_O">O<sub>2</sub></span></span> +  <span class="cpd_C4H10"> <span class="coef_C4H10"></span><span class="eall_C erx_C">C<sub>4</sub></span><span class="eall_H erx_H">H<sub>10</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_H2O"> <span class="coef_H2O"></span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span> +  <span class="cpd_CO2"> <span class="coef_CO2"></span><span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>2</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 22,
    '<span class="cpd_O2"> <span class="coef_O2">13</span><span class="eall_O erx_O">O<sub>2</sub></span></span> +  <span class="cpd_C4H10"> <span class="coef_C4H10">2</span><span class="eall_C erx_C">C<sub>4</sub></span><span class="eall_H erx_H">H<sub>10</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_H2O"> <span class="coef_H2O">10</span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span> +  <span class="cpd_CO2"> <span class="coef_CO2">8</span><span class="eall_C epd_C">C</span><span class="eall_O epd_O">O<sub>2</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '1|Consider compounds with element(s)  <span class="eall_C">C</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '2|Try to balance <span class="epd_C">C</span>\'s by multiplying products\' coefficients by 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '3|new <span class="cpd_CO2">CO2</span> coefficient is  <span class="coef_CO2">4</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '4|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '5|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 8');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '6|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '7|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '8|Check if the total <span class="epd_H">H</span> count on product side is a &gt\;1 factor of 8, the difference in <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '9|8 is exactly 4 times larger than the product <span class="epd_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '10|Increase coefficients by 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '11|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">5</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '12|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '13|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 11');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '14|Check compounds only with <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '15|Inspect reactants to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '16|Check if the total <span class="erx_O">O</span> count on reactant side is a &gt\;1 factor of 11, the difference in <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '17|Total <span class="erx_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '18|Check compounds with <span class="erx_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '19|Try to balance <span class="erx_O">O</span>\'s by multiplying reactants\' coefficients by 13');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '20|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">13</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '21|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '22|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 13');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '23|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '24|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '25|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 13, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '26|13 is exactly 13 times larger than the product <span class="epd_O">O</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '27|Increase coefficients by 13');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '28|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">18</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '29|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '30|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 26');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '31|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '32|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '33|No candidates found for H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '34|Total <span class="erx_H">H</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '35|Check compounds with <span class="erx_H">H</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '36|Try to balance <span class="erx_H">H</span>\'s by multiplying reactants\' coefficients by 18');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '37|new <span class="cpd_C4H10">C4H10</span> coefficient is  <span class="coef_C4H10">18</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '38|Consider compounds with element(s)  <span class="eall_C">C</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '39|Find difference in product count and reaction count of <span class="eall_C">C</span>. It is 68');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '40|Check compounds only with <span class="epd_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '41|Inspect products to see if compounds with C can be adjusted to balance C');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '42|Check if the total <span class="epd_C">C</span> count on product side is a &gt\;1 factor of 68, the difference in <span class="epd_C">C</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '43|68 is exactly 68 times larger than the product <span class="epd_C">C</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '44|Increase coefficients by 68');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '45|new <span class="cpd_CO2">CO2</span> coefficient is  <span class="coef_CO2">72</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '46|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '47|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 144');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '48|Check compounds only with <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '49|Inspect products to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '50|Check if the total <span class="epd_H">H</span> count on product side is a &gt\;1 factor of 144, the difference in <span class="epd_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '51|144 is exactly 72 times larger than the product <span class="epd_H">H</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '52|Increase coefficients by 72');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '53|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">90</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '54|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '55|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 208');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '56|Check compounds only with <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '57|Inspect reactants to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '58|Check if the total <span class="erx_O">O</span> count on reactant side is a &gt\;1 factor of 208, the difference in <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '59|208 is exactly 104 times larger than the reactant <span class="erx_O">O</span> count, 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '60|Increase coefficients by 104');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '61|new <span class="cpd_O2">O2</span> coefficient is  <span class="coef_O2">117</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '62|Coefficients reduced by common factor of 9');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 22,
    '63|A better coefficient sum could have been used during balancing to get the lowest possible integer coefficients.');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 22,
    '63,O,26,26');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 22,
    '63,C,8,8');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 22,
    '63,H,20,20');

-- Test case 23, Large coefficients - test Z* element boundary case
-- Reaction: Zn7 + P17 = P4Zn10
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 23,
    '<span class="cpd_Zn7"> <span class="coef_Zn7"></span><span class="eall_Zn erx_Zn">Zn<sub>7</sub></span></span> +  <span class="cpd_P17"> <span class="coef_P17"></span><span class="eall_P erx_P">P<sub>17</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_P4Zn10"> <span class="coef_P4Zn10"></span><span class="eall_P epd_P">P<sub>4</sub></span><span class="eall_Zn epd_Zn">Zn<sub>10</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 23,
    '<span class="cpd_Zn7"> <span class="coef_Zn7">170</span><span class="eall_Zn erx_Zn">Zn<sub>7</sub></span></span> +  <span class="cpd_P17"> <span class="coef_P17">28</span><span class="eall_P erx_P">P<sub>17</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_P4Zn10"> <span class="coef_P4Zn10">119</span><span class="eall_P epd_P">P<sub>4</sub></span><span class="eall_Zn epd_Zn">Zn<sub>10</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '1|Consider compounds with element(s)  <span class="eall_Zn">Zn</span>, <span class="eall_P">P</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '2|Try to balance <span class="erx_P">P</span>\'s by multiplying reactants\' coefficients by 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '3|new <span class="cpd_P17">P17</span> coefficient is  <span class="coef_P17">4</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '4|Try to balance <span class="epd_P">P</span>\'s by multiplying products\' coefficients by 17');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '5|new <span class="cpd_P4Zn10">P4Zn10</span> coefficient is  <span class="coef_P4Zn10">17</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '6|Consider compounds with element(s)  <span class="eall_Zn">Zn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '7|Find difference in product count and reaction count of <span class="eall_Zn">Zn</span>. It is 163');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '8|Check compounds only with <span class="erx_Zn">Zn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '9|Inspect reactants to see if compounds with Zn can be adjusted to balance Zn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '10|Check if the total <span class="erx_Zn">Zn</span> count on reactant side is a &gt\;1 factor of 163, the difference in <span class="erx_Zn">Zn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '11|Total <span class="erx_Zn">Zn</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '12|Check compounds with <span class="erx_Zn">Zn</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '13|Try to balance <span class="erx_Zn">Zn</span>\'s by multiplying reactants\' coefficients by 170');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '14|new <span class="cpd_Zn7">Zn7</span> coefficient is  <span class="coef_Zn7">170</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '15|Consider compounds with element(s)  <span class="eall_Zn">Zn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '16|Find difference in product count and reaction count of <span class="eall_Zn">Zn</span>. It is 1020');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '17|Check compounds only with <span class="epd_Zn">Zn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '18|Inspect products to see if compounds with Zn can be adjusted to balance Zn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '19|No candidates found for Zn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '20|Total <span class="epd_Zn">Zn</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '21|Check compounds with <span class="epd_Zn">Zn</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '22|Try to balance <span class="epd_Zn">Zn</span>\'s by multiplying products\' coefficients by 119');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '23|new <span class="cpd_P4Zn10">P4Zn10</span> coefficient is  <span class="coef_P4Zn10">119</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '24|Consider compounds with element(s)  <span class="eall_P">P</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '25|Find difference in product count and reaction count of <span class="eall_P">P</span>. It is 408');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '26|Check compounds only with <span class="erx_P">P</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '27|Inspect reactants to see if compounds with P can be adjusted to balance P');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '28|Check if the total <span class="erx_P">P</span> count on reactant side is a &gt\;1 factor of 408, the difference in <span class="erx_P">P</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '29|408 is exactly 24 times larger than the reactant <span class="erx_P">P</span> count, 17');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '30|Increase coefficients by 24');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 23,
    '31|new <span class="cpd_P17">P17</span> coefficient is  <span class="coef_P17">28</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 23,
    '31,Zn,1190,1190');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 23,
    '31,P,476,476');

-- Test case 24, Large coefficients with O and another element
-- Reaction: O7 + P17 = P4O10
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 24,
    '<span class="cpd_O7"> <span class="coef_O7"></span><span class="eall_O erx_O">O<sub>7</sub></span></span> +  <span class="cpd_P17"> <span class="coef_P17"></span><span class="eall_P erx_P">P<sub>17</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_P4O10"> <span class="coef_P4O10"></span><span class="eall_P epd_P">P<sub>4</sub></span><span class="eall_O epd_O">O<sub>10</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 24,
    '<span class="cpd_O7"> <span class="coef_O7">170</span><span class="eall_O erx_O">O<sub>7</sub></span></span> +  <span class="cpd_P17"> <span class="coef_P17">28</span><span class="eall_P erx_P">P<sub>17</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_P4O10"> <span class="coef_P4O10">119</span><span class="eall_P epd_P">P<sub>4</sub></span><span class="eall_O epd_O">O<sub>10</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '1|Consider compounds with element(s)  <span class="eall_P">P</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '2|Try to balance <span class="erx_P">P</span>\'s by multiplying reactants\' coefficients by 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '3|new <span class="cpd_P17">P17</span> coefficient is  <span class="coef_P17">4</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '4|Try to balance <span class="epd_P">P</span>\'s by multiplying products\' coefficients by 17');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '5|new <span class="cpd_P4O10">P4O10</span> coefficient is  <span class="coef_P4O10">17</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '6|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '7|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 163');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '8|Check compounds only with <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '9|Inspect reactants to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '10|Check if the total <span class="erx_O">O</span> count on reactant side is a &gt\;1 factor of 163, the difference in <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '11|Total <span class="erx_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '12|Check compounds with <span class="erx_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '13|Try to balance <span class="erx_O">O</span>\'s by multiplying reactants\' coefficients by 170');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '14|new <span class="cpd_O7">O7</span> coefficient is  <span class="coef_O7">170</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '15|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '16|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 1020');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '17|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '18|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '19|No candidates found for O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '20|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '21|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '22|Try to balance <span class="epd_O">O</span>\'s by multiplying products\' coefficients by 119');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '23|new <span class="cpd_P4O10">P4O10</span> coefficient is  <span class="coef_P4O10">119</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '24|Consider compounds with element(s)  <span class="eall_P">P</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '25|Find difference in product count and reaction count of <span class="eall_P">P</span>. It is 408');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '26|Check compounds only with <span class="erx_P">P</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '27|Inspect reactants to see if compounds with P can be adjusted to balance P');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '28|Check if the total <span class="erx_P">P</span> count on reactant side is a &gt\;1 factor of 408, the difference in <span class="erx_P">P</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '29|408 is exactly 24 times larger than the reactant <span class="erx_P">P</span> count, 17');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '30|Increase coefficients by 24');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 24,
    '31|new <span class="cpd_P17">P17</span> coefficient is  <span class="coef_P17">28</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 24,
    '31,O,1190,1190');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 24,
    '31,P,476,476');

-- Test case 25, Large coefficients with O and another element - reactants reversed
-- Reaction: P17 + O7 = P4O10
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 25,
    '<span class="cpd_P17"> <span class="coef_P17"></span><span class="eall_P erx_P">P<sub>17</sub></span></span> +  <span class="cpd_O7"> <span class="coef_O7"></span><span class="eall_O erx_O">O<sub>7</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_P4O10"> <span class="coef_P4O10"></span><span class="eall_P epd_P">P<sub>4</sub></span><span class="eall_O epd_O">O<sub>10</sub></span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 25,
    '<span class="cpd_P17"> <span class="coef_P17">28</span><span class="eall_P erx_P">P<sub>17</sub></span></span> +  <span class="cpd_O7"> <span class="coef_O7">170</span><span class="eall_O erx_O">O<sub>7</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_P4O10"> <span class="coef_P4O10">119</span><span class="eall_P epd_P">P<sub>4</sub></span><span class="eall_O epd_O">O<sub>10</sub></span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '1|Consider compounds with element(s)  <span class="eall_P">P</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '2|Try to balance <span class="erx_P">P</span>\'s by multiplying reactants\' coefficients by 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '3|new <span class="cpd_P17">P17</span> coefficient is  <span class="coef_P17">4</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '4|Try to balance <span class="epd_P">P</span>\'s by multiplying products\' coefficients by 17');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '5|new <span class="cpd_P4O10">P4O10</span> coefficient is  <span class="coef_P4O10">17</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '6|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '7|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 163');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '8|Check compounds only with <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '9|Inspect reactants to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '10|Check if the total <span class="erx_O">O</span> count on reactant side is a &gt\;1 factor of 163, the difference in <span class="erx_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '11|Total <span class="erx_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '12|Check compounds with <span class="erx_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '13|Try to balance <span class="erx_O">O</span>\'s by multiplying reactants\' coefficients by 170');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '14|new <span class="cpd_O7">O7</span> coefficient is  <span class="coef_O7">170</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '15|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '16|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 1020');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '17|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '18|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '19|No candidates found for O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '20|Total <span class="epd_O">O</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '21|Check compounds with <span class="epd_O">O</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '22|Try to balance <span class="epd_O">O</span>\'s by multiplying products\' coefficients by 119');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '23|new <span class="cpd_P4O10">P4O10</span> coefficient is  <span class="coef_P4O10">119</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '24|Consider compounds with element(s)  <span class="eall_P">P</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '25|Find difference in product count and reaction count of <span class="eall_P">P</span>. It is 408');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '26|Check compounds only with <span class="erx_P">P</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '27|Inspect reactants to see if compounds with P can be adjusted to balance P');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '28|Check if the total <span class="erx_P">P</span> count on reactant side is a &gt\;1 factor of 408, the difference in <span class="erx_P">P</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '29|408 is exactly 24 times larger than the reactant <span class="erx_P">P</span> count, 17');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '30|Increase coefficients by 24');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 25,
    '31|new <span class="cpd_P17">P17</span> coefficient is  <span class="coef_P17">28</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 25,
    '31,P,476,476');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 25,
    '31,O,1190,1190');

-- Test case 26, Two PA ions with O resulting in only one PA ion with O
-- Reaction: MnO2 +  KOH + O2 = K2MnO4 + H2O
insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    1, 26,
    '<span class="cpd_MnO2"> <span class="coef_MnO2"></span><span class="eall_Mn erx_Mn">Mn</span><span class="eall_O erx_O">O<sub>2</sub></span></span> +  <span class="cpd_KOH"> <span class="coef_KOH"></span><span class="eall_K erx_K">K</span><span class="eall_O erx_O">O</span><span class="eall_H erx_H">H</span></span> +  <span class="cpd_O2"> <span class="coef_O2"></span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_K2MnO4"> <span class="coef_K2MnO4"></span><span class="eall_K epd_K">K<sub>2</sub></span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_H2O"> <span class="coef_H2O"></span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span>');


insert into "verify_reaction" ("reaction_type", "case_id", "vr_text")
    values (
    2, 26,
    '<span class="cpd_MnO2"> <span class="coef_MnO2">2</span><span class="eall_Mn erx_Mn">Mn</span><span class="eall_O erx_O">O<sub>2</sub></span></span> +  <span class="cpd_KOH"> <span class="coef_KOH">4</span><span class="eall_K erx_K">K</span><span class="eall_O erx_O">O</span><span class="eall_H erx_H">H</span></span> +  <span class="cpd_O2"> <span class="coef_O2"></span><span class="eall_O erx_O">O<sub>2</sub></span></span> <i class="fa fa-long-arrow-right fa-lg"></i>  <span class="cpd_K2MnO4"> <span class="coef_K2MnO4">2</span><span class="eall_K epd_K">K<sub>2</sub></span><span class="eall_Mn epd_Mn">Mn</span><span class="eall_O epd_O">O<sub>4</sub></span></span> +  <span class="cpd_H2O"> <span class="coef_H2O">2</span><span class="eall_H epd_H">H<sub>2</sub></span><span class="eall_O epd_O">O</span></span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '1|Consider compounds with element(s)  <span class="eall_K">K</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '2|Try to balance <span class="erx_K">K</span>\'s by multiplying reactants\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '3|new <span class="cpd_KOH">KOH</span> coefficient is  <span class="coef_KOH">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '4|Other elements are balanced. Consider compounds with element <span class="eall_O">O</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '5|Find difference in product count and reaction count of <span class="eall_O">O</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '6|Check compounds only with <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '7|Inspect products to see if compounds with O can be adjusted to balance O');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '8|Check if the total <span class="epd_O">O</span> count on product side is a &gt\;1 factor of 1, the difference in <span class="epd_O">O</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '9|1 is exactly 1 times larger than the product <span class="epd_O">O</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '10|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '11|new <span class="cpd_H2O">H2O</span> coefficient is  <span class="coef_H2O">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '12|Other elements are balanced. Consider compounds with element <span class="eall_H">H</span>.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '13|Find difference in product count and reaction count of <span class="eall_H">H</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '14|Check compounds only with <span class="erx_H">H</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '15|Inspect reactants to see if compounds with H can be adjusted to balance H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '16|No candidates found for H');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '17|Total <span class="erx_H">H</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '18|Check compounds with <span class="erx_H">H</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '19|Try to balance <span class="erx_H">H</span>\'s by multiplying reactants\' coefficients by 4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '20|new <span class="cpd_KOH">KOH</span> coefficient is  <span class="coef_KOH">4</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '21|Consider compounds with element(s)  <span class="eall_K">K</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '22|Find difference in product count and reaction count of <span class="eall_K">K</span>. It is 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '23|Check compounds only with <span class="epd_K">K</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '24|Inspect products to see if compounds with K can be adjusted to balance K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '25|No candidates found for K');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '26|Total <span class="epd_K">K</span> count is not a factor of difference.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '27|Check compounds with <span class="epd_K">K</span> and one or more other elememnts');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '28|Try to balance <span class="epd_K">K</span>\'s by multiplying products\' coefficients by 2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '29|new <span class="cpd_K2MnO4">K2MnO4</span> coefficient is  <span class="coef_K2MnO4">2</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '30|Consider compounds with element(s)  <span class="eall_Mn">Mn</span> for next balancing step.');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '31|Find difference in product count and reaction count of <span class="eall_Mn">Mn</span>. It is 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '32|Check compounds only with <span class="erx_Mn">Mn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '33|Inspect reactants to see if compounds with Mn can be adjusted to balance Mn');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '34|Check if the total <span class="erx_Mn">Mn</span> count on reactant side is a &gt\;1 factor of 1, the difference in <span class="erx_Mn">Mn</span>');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '35|1 is exactly 1 times larger than the reactant <span class="erx_Mn">Mn</span> count, 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '36|Increase coefficients by 1');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (1, 26,
    '37|new <span class="cpd_MnO2">MnO2</span> coefficient is  <span class="coef_MnO2">2</span>');


insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 26,
    '37,Mn,2,2');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 26,
    '37,O,10,10');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 26,
    '37,H,4,4');
insert into "verify_step" ("vs_type_id", "case_id", "vs_text")
    values (5, 26,
    '37,K,4,4');

