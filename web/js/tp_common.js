function nonWSTrimLeft(instr, trimchars) {
    let rv = instr;
    let pos = 0;
    let tcfound = trimchars.indexOf(instr[pos]) >= 0;
    while (pos < instr.length && tcfound) {
        pos++;
        tcfound = trimchars.indexOf(instr[pos]) >= 0;    
    };
    if (tcfound) {
        rv  = "";
    } else {
        rv = instr.substr(pos);
    };
    
    return rv;    
}
    
function nonWSTrimRight(instr, trimchars) {
    let rv = instr;
    let pos = instr.length - 1;
    let tcfound = trimchars.indexOf(instr[pos]) >= 0;
    while (pos > -1 && tcfound) {
        pos--;
        tcfound = trimchars.indexOf(instr[pos]) >= 0;    
    };
    if (tcfound) {
        rv  = "";
    } else {
        rv = instr.substr(0, pos + 1);
    };
    
    return rv;    
}
    
function nonWSTrim(instr, trimchars) {
    let rv = nonWSTrimLeft(instr, trimchars);
    rv = nonWSTrimRight(rv, trimchars);
    return rv;
}

// This function is needed because JS dynamically updates the iterator for
// a loop. Therefore, the initial state of an iterator, which is the assumed
// state, is not so
function copyMap(inmap) {
    let rv = new Map();
    for (var k of inmap.keys()){
        rv.set(k, inmap.get(k));
    };
    return rv;
};

var PT = new Map();
PT.set("Ac",["Actinium",89]);
PT.set("Ag",["Silver",47]);
PT.set("Al",["Aluminum",13]);
PT.set("Am",["Americium",95]);
PT.set("Ar",["Argon",18]);
PT.set("As",["Arsenic",33]);
PT.set("At",["Astatine",85]);
PT.set("Au",["Gold",79]);
PT.set("B",["Boron",5]);
PT.set("Ba",["Barium",56]);
PT.set("Be",["Beryllium",4]);
PT.set("Bh",["Bohrium",107]);
PT.set("Bi",["Bismuth",83]);
PT.set("Bk",["Berkelium",97]);
PT.set("Br",["Bromine",35]);
PT.set("C",["Carbon",6]);
PT.set("Ca",["Calcium",20]);
PT.set("Cd",["Cadmium",48]);
PT.set("Ce",["Cerium",58]);
PT.set("Cf",["Californium",98]);
PT.set("Cl",["Chlorine",17]);
PT.set("Cm",["Curium",96]);
PT.set("Co",["Cobalt",27]);
PT.set("Cr",["Chromium",24]);
PT.set("Cs",["Cesium",55]);
PT.set("Cu",["Copper",29]);
PT.set("Db",["Dubnium",105]);
PT.set("Ds",["Darmstadtium",110]);
PT.set("Dy",["Dysprosium",66]);
PT.set("Er",["Erbium",68]);
PT.set("Es",["Einsteinium",99]);
PT.set("Eu",["Europium",63]);
PT.set("F",["Fluorine",9]);
PT.set("Fe",["Iron",26]);
PT.set("Fm",["Fermium",100]);
PT.set("Fr",["Francium",87]);
PT.set("Ga",["Gallium",31]);
PT.set("Gd",["Gadolinium",64]);
PT.set("Ge",["Germanium",32]);
PT.set("H",["Hydrogen",1]);
PT.set("He",["Helium",2]);
PT.set("Hf",["Hafnium",72]);
PT.set("Hg",["Mercury",80]);
PT.set("Ho",["Holmium",67]);
PT.set("Hs",["Hassium",108]);
PT.set("I",["Iodine",53]);
PT.set("In",["Indium",49]);
PT.set("Ir",["Iridium",77]);
PT.set("K",["Potassium",19]);
PT.set("Kr",["Krypton",36]);
PT.set("La",["Lanthanum",57]);
PT.set("Li",["Lithium",3]);
PT.set("Lr",["Lawrencium",103]);
PT.set("Lu",["Lutetium",71]);
PT.set("Md",["Mendelevium",101]);
PT.set("Mg",["Magnesium",12]);
PT.set("Mn",["Manganese",25]);
PT.set("Mo",["Molybdenum",42]);
PT.set("Mt",["Meitnerium",109]);
PT.set("N",["Nitrogen",7]);
PT.set("Na",["Sodium",11]);
PT.set("Nb",["Niobium",41]);
PT.set("Nd",["Neodymium",60]);
PT.set("Ne",["Neon",10]);
PT.set("Ni",["Nickel",28]);
PT.set("No",["Nobelium",102]);
PT.set("Np",["Neptunium",93]);
PT.set("O",["Oxygen",8]);
PT.set("Os",["Osmium",76]);
PT.set("P",["Phosphorus",15]);
PT.set("Pa",["Protactinium",91]);
PT.set("Pb",["Lead",82]);
PT.set("Pd",["Palladium",46]);
PT.set("Pm",["Promethium",61]);
PT.set("Po",["Polonium",84]);
PT.set("Pr",["Praseodymium",59]);
PT.set("Pt",["Platinum",78]);
PT.set("Pu",["Plutonium",94]);
PT.set("Ra",["Radium",88]);
PT.set("Rb",["Rubidium",37]);
PT.set("Re",["Rhenium",75]);
PT.set("Rf",["Rutherfordium",104]);
PT.set("Rg",["Roentgenium",111]);
PT.set("Rh",["Rhodium",45]);
PT.set("Rn",["Radon",86]);
PT.set("Ru",["Ruthenium",44]);
PT.set("S",["Sulfur",16]);
PT.set("Sb",["Antimony",51]);
PT.set("Sc",["Scandium",21]);
PT.set("Se",["Selenium",34]);
PT.set("Sg",["Seaborgium",106]);
PT.set("Si",["Silicon",14]);
PT.set("Sm",["Samarium",62]);
PT.set("Sn",["Tin",50]);
PT.set("Sr",["Strontium",38]);
PT.set("Ta",["Tantalum",73]);
PT.set("Tb",["Terbium",65]);
PT.set("Tc",["Technetium",43]);
PT.set("Te",["Tellurium",52]);
PT.set("Th",["Thorium",90]);
PT.set("Ti",["Titanium",22]);
PT.set("Tl",["Thallium",81]);
PT.set("Tm",["Thulium",69]);
PT.set("U",["Uranium",92]);
PT.set("V",["Vanadium",23]);
PT.set("W",["Tungsten",74]);
PT.set("Xe",["Xenon",54]);
PT.set("Y",["Yttrium",39]);
PT.set("Yb",["Ytterbium",70]);
PT.set("Zn",["Zinc",30]);
PT.set("Zr",["Zirconium",40]);
