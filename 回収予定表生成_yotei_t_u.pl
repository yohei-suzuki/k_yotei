#!/usr/local/bin/perl

use strict;

print "ファイル名入力（例：0326）";
my $d = <STDIN>;

chomp($d);

open DATA,"${d}-yotei.csv";
my @data = <DATA>;
close DATA;

open DATA2,"${d}-t.csv";
my @data2 = <DATA2>;
close DATA2;

my $day = &day;
open OUT ,">$day住所入り.csv";
print OUT "回収日,コード,得意先名,郵便番号,住所,電話番号,差引残高,請求日,,備考\n";

foreach ( @data ){
    my @hoge = split/,/,;#/;
    $hoge[17] = &gomi($hoge[17]);
    $hoge[2] = &gomi($hoge[2]);
    chomp( $hoge[17] );
    #print "$hoge[2] $hoge[17] --\n";
    #if( "集金" eq $hoge[17] ){
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
		$hoge2[9] =~ s/釧路市//;
		$hoge2[9] =~ s/釧路町//;

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
		$hoge[49] =~ s/広告//;
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
      $out = "3ヶ月前分";
    } elsif($code == '21192'){
      $out = "金額確認";
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
    #平成27年3月1日
    #my @d1 = split/平成/,$day;
    #my @d2 = split/年/,$d1[1];
    #my $year = $d2[0];
    
    #my @d3 = split/月/,$d2[1];
    #my $tsuki = $d3[0];
    #my @d4 = split/日/,$d3[1];
    #my $hi = $d4[0];
    #print "$year $tsuki $hi\n";
    $day =~ s/\///g;
    return $day
    #return "$year$tsuki$hi";
}