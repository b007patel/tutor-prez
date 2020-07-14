<?php

// compound ratios for a given element on either side of the reaction
// arrow (= sign)
abstract class CompoundRatios {
        const CRunk=0;        // unknown, ignore ratio and add entry
        const CR1to1=1;        // one cmpd on each side
        const CR1toX=2;        // one cmpd on one side to many cmpds on other
        const CRXtoY=3;        // few cmpds on one side to many cmpds on other
}

// BP -- CANDIDATE FOR A COMMON UTILITY LIBRARY!!
// return a zero-based indexed array from a CSV file, ignoring lines
// starting with the comment character, '#'
function read_csv($csv_fname) {
    $csvf = @fopen($csv_fname, "r");
    $csvtab = [];
    if ($csvf) {
        $currl = fgetcsv($csvf);
        while ( $currl ) {
            if (count($currl) == 1 && strpos($currl[0], "#") === 0) {
                // Do nothing. Hopefully writing the if stmt this way
                // takes advantage of short-circuit evaluation
            } else {
                   $csvtab[] = $currl;
            }
            $currl = fgetcsv($csvf);
        }
        if (count($csvtab) > 0) return $csvtab;
        return null;
        //print_r($csvtab);
    } else {
        return null;
        // print("FILE NOT FOUND!!\n");
    }
}

function prime_factor($num) {
    $primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29];
    $numprimes = count($primes);
    $dividend = $num;
    $limit = (int)ceil(sqrt($num));
    $i = 0;
    $divisor = $primes[$i];
    while ($divisor <= $limit) {
        while ($dividend % $divisor == 0) {
            $dividend = $dividend / $divisor;
            if (empty($rtval[$divisor])) {
                $rtval[$divisor] = 1;
            } else {
                $rtval[$divisor] += 1;
            }
        }
        $i++;
        if ($i < $numprimes) {
            $divisor = $primes[$i];
        } else {
            $divisor += 2;
        }
    }

    if ($dividend > 1 && $dividend < $num) {
        if (empty($rtval[$dividend])) {
            $rtval[$dividend] = 1;
        } else {
            $rtval[$dividend] += 1;
        }
    }
    if (empty($rtval) || $rtval == NULL) {
        $rtval[$num] = 1;
    }
    return $rtval;
}

function lcm($num1, $num2) {
    $pf1 = prime_factor($num1);
    $pf2 = prime_factor($num2);

    $lcm = 1;
    foreach ($pf1 as $factor => $power) {
        if (array_key_exists($factor, $pf2)) {
            $highest_power = $power;
            if ($pf2[$factor] > $power) {
                $highest_power = $pf2[$factor];
            }
            for ($i=0; $i < $highest_power; $i++) {
                $lcm *= $factor;
            }
            unset($pf2[$factor]);
        } else {
            for ($i=0; $i < $power; $i++) {
                $lcm *= $factor;
            }
        }
    }
    foreach ($pf2 as $factor => $power) {
        for ($i=0; $i < $power; $i++) {
            $lcm *= $factor;
        }
    }

    return $lcm;
}

function gcf($num1, $num2) {
    $pf1 = prime_factor($num1);
    $pf2 = prime_factor($num2);

    $gcf = 1;
    foreach ($pf1 as $factor => $power) {
        if (array_key_exists($factor, $pf2)) {
            $lowest_power = $power;
            if ($pf2[$factor] < $power) {
                $lowest_power = $pf2[$factor];
            }
            for ($i=0; $i < $lowest_power; $i++) {
                $gcf *= $factor;
            }
        }
    }

    return $gcf;
}
