#!/usr/local/bin/perl

use strict;

print "�t�@�C�������́i��F0326�j";
my $d = <STDIN>;

chomp($d);

open DATA,"${d}-yotei.csv";
my @data = <DATA>;
close DATA;

open DATA2,"${d}-t.csv";
my @data2 = <DATA2>;
close DATA2;

my $day = &day;
open OUT ,">$day�Z������.csv";
print OUT "�����,�R�[�h,���Ӑ於,�X�֔ԍ�,�Z��,�d�b�ԍ�,�����c��,������,,���l\n";

foreach ( @data ){
    my @hoge = split/,/,;#/;
    $hoge[17] = &gomi($hoge[17]);
    $hoge[2] = &gomi($hoge[2]);
    chomp( $hoge[17] );
    #print "$hoge[2] $hoge[17] --\n";
    #if( "�W��" eq $hoge[17] ){
    if( $hoge[17] ){
	$hoge[2] = &gomi($hoge[2]);
        #print "$hoge[2] $hoge[3]\n";
	foreach ( @data2 ){
	    my @hoge2 = split/,/,;#/;
	    $hoge2[0] = &gomi($hoge2[0]);
            if( $hoge[2] eq $hoge2[0] ){
		$hoge2[2] = &gomi($hoge2[2]);
		$hoge2[8] = &gomi($hoge2[8]);
		$hoge2[9] = &gomi($hoge2[9]);
		$hoge2[10] = &gomi($hoge2[10]);
		$hoge2[11] = &gomi($hoge2[11]);
		$hoge2[9] =~ s/���H�s//;
		$hoge2[9] =~ s/���H��//;

                my $s = $hoge[16];
                $hoge[16] = &dayhen($hoge[16]);

                my $uri = &uri($hoge[2],$hoge[7],$hoge[16]);
		print "$hoge[1],$hoge2[0],$hoge2[2],$hoge2[8],$hoge2[9],$hoge2[11],$hoge[6],$s,$uri\n";
                #print "$hoge[1],$hoge[16]\n";
                print OUT "$hoge[1],$hoge2[0],$hoge2[2],$hoge2[8],$hoge2[9],$hoge2[11],$hoge[6],$s,,$uri\n";

	    }
	}
    }
}
#my $hoge = <STDIN>;
###############################################
sub uri {
    my($code,$gaku,$sime) = @_;
    print "$code $gaku  a $sime -------\n";

    open DATA, "${d}-u.csv";
    my @uri = <DATA>;
    close DATA;
    @uri = reverse @uri;
    my $out;
    my $zan = $gaku;
    foreach (@uri) {
	my @hoge = split/,/,$_;#/;
	$hoge[9] = &gomi($hoge[9]);
        $hoge[3] =  &dayhen($hoge[3]);
        #print "----  $hoge[3]\n";
	if ($gaku > 0) {
	    #if ($code == $hoge[9]) {
            if ($code == $hoge[9] && $sime >= $hoge[3]) {
                print "-- $sime >= $hoge[3]\n";
		$hoge[49] = &gomi($hoge[49]);
		$hoge[21] = &gomi($hoge[21]);
		my $tan = substr($hoge[21], 0, 4);
		$hoge[49] =~ s/�L��//;
		$hoge[58] = &gomi($hoge[58]);
		$hoge[75] = &gomi($hoge[75]);
		my $kei = $hoge[58] + $hoge[75];
		$gaku = $gaku - $kei;
		if ($gaku >= 0) {
		    $out .= "$hoge[3]$hoge[49]$kei$tan ";
		} else {
		    my $zan = abs($gaku);
		    my $zan_2 = $kei - $zan;
		    $out .= "$hoge[3]$hoge[49]$zan_2$tan ";
		}
		
	    }
	}
    }

    if($code == '55111' || $code == '15576'){
      $out = "3�����O��";
    } elsif($code == '21192'){
      $out = "���z�m�F";
    }

    return $out;
}
sub niti {
	my($niti) = @_;
	$niti =~ s/\"//g;
	my $nen = substr($niti,0,2);
	my $tuki = substr($niti,2,2);
	my $niti = substr($niti,4,2);
	my $day = "$tuki/$niti";
	return $day; 
}

sub gomi {
	my($hoge) = @_;
	$hoge =~ s/\"//g;
	$hoge =~ s/ //g;
	return $hoge;
}

sub day {
	my( $sec,$min,$hour,$day,$mon,$year,$wday ) = localtime( time );
	$year +=1900;
	$mon = sprintf( "%02d" , $mon+1 );
	$day = sprintf( "%02d" , $day );
	$hour = sprintf( "%02d" , $hour );
	$min = sprintf( "%02d" , $min );
	$sec = sprintf( "%02d" , $sec );
	return "$mon$day";
}

sub dayhen {
    my($day) = @_;
    #����27�N3��1��
    #my @d1 = split/����/,$day;
    #my @d2 = split/�N/,$d1[1];
    #my $year = $d2[0];
    
    #my @d3 = split/��/,$d2[1];
    #my $tsuki = $d3[0];
    #my @d4 = split/��/,$d3[1];
    #my $hi = $d4[0];
    #print "$year $tsuki $hi\n";
    $day =~ s/\///g;
    return $day
    #return "$year$tsuki$hi";
}