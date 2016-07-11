<?php

// compound ratios for a given element on either side of the reaction
// arrow (= sign)
abstract class CompoundRatios {
        const CRunk=0;        // unknown, ignore ratio and add entry
        const CR1to1=1;        // one cmpd on each side
        const CR1toX=2;        // one cmpd on one side to many cmpds on other
        const CRXtoY=3;        // few cmpds on one side to many cmpds on other
}

function prime_factor($num) {
    $primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29];
    $numprimes = count($primes);
    $dividend = $num;
    $limit = (int)ceil(sqrt($num));
    $i = 0;
    $divisor = $primes[$i];
    $rtval = NULL;
    while ($divisor <= $limit) {
        while ($dividend % $divisor == 0) {
            $dividend = $dividend / $divisor;
            $rtval[$divisor] += 1;
        }
        $i++;
        if ($i < $numprimes) {
            $divisor = $primes[$i];
        } else {
            $divisor += 2;
        }
    }
    
    if ($dividend > 1 && $dividend < $num) {
        $rtval[$dividend] += 1;
    }
    if ($rtval == NULL) {
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
