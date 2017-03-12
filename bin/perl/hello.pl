#!/usr/bin/perl
#use strict;
#use warnings;
use Astro::MoonPhase;


( $MoonPhase,
    $MoonIllum,
    $MoonAge,
    $MoonDist,
    $MoonAng,
    $SunDist,
    $SunAng ) = phase($seconds_since_1970);

@phases  = phasehunt($seconds_since_1970);

($phase, @times) = phaselist($start, $stop);

@phases = phasehunt();
print "New Moon      = ", scalar(localtime($phases[0])), "\n";
print "First quarter = ", scalar(localtime($phases[1])), "\n";
print "Full moon     = ", scalar(localtime($phases[2])), "\n";
print "Last quarter  = ", scalar(localtime($phases[3])), "\n";
print "New Moon      = ", scalar(localtime($phases[4])), "\n";


#print $MoonPhase
#print "Hello, World!\n";
