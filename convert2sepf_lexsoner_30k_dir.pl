use warnings;
use utf8;

$nsize= "30K";

$keyfile = "/vol/tensusers/ihendrickx/Data/LSA/R_Sonar/Sonar10K1line/sonar_top$nsize"."_wordllist";
#lees het lexicon in, en bewaar het in de hash %woorden.
%woorden=();
open(SFILE,$keyfile);
while(<SFILE>){

  $line =$_;
  chomp $line;
 if($line =~ /(.*)\b/){
  $woorden{$1}=1;
 #print "($1)\n";
 }}
 close(SFILE);



# lees de want/omdat file in. 
#Format: filename position-nr Qpart  Ppart
# check Qpart en Ppart en als beide een woord in het CGN lexicon bevatten, scrijf ze dan ieder naar een file in een directory.
#WR-P-P-G-0000517484.p.7.s.2.w.10	NORM	natuurlijk spelen de tijd niet in ons voordeel ,	++want++	 het aantal spelen wedstrijd worden almaar groot .

#$infile ="/vol/bigdata/users/ihendrickx/ExpLSA/Inspectie/sonarnews100K.wantQP.splitQP.txt";
#$outdir = "/vol/tensusers/ihendrickx/Data/LSA/R_Sonar/sonar_10knews/vocab_top$nsize/wantQP";
#$nameT="wantQP";


$infile ="/vol/bigdata/users/ihendrickx/ExpLSA/Inspectie/sonarnews100K.omdatQP.splitQP.check.txt";
$outdir = "/vol/tensusers/ihendrickx/Data/LSA/R_Sonar/sonar_10knews/vocab_top$nsize/omdatQP";
$nameT="omdatQP";

$teller=0;
open(FILE, "<:encoding(UTF-8)",$infile) || die " help";
while(<FILE>)
{

$line =$_;
chomp $line;
$teller++;
my @haswordsQ=();
my @haswordsP=();

$line =~ tr/\r//d;

if($line =~ m/\w\+\+/)
{
 ($filename, $type, $Qpart,$voegwoord, $Ppart) =split /\t/, $line;

# print "$teller  $Qpart,----$Ppart\n";
 

 @haswordsQ = &check_lex($Qpart);
 @haswordsP = &check_lex($Ppart);

 #iedere zin naar een aparte directory geschreven met 2 files: Q en P
 if(@haswordsQ && @haswordsP)
 {
   #maak een dir
   $outname ="$outdir/$nameT.$teller";
   system("mkdir $outname");
  
   #print 2 files
	open(OUTFILE, ">:encoding(UTF-8)","$outname/$nameT.$teller.Q") || die "Q help";
 	print OUTFILE join " ", @haswordsQ, "\n";	
	close(OUTFILE);	
 	
 	open(OUTFILE, ">:encoding(UTF-8)","$outname/$nameT.$teller.P") || die "P help";
 	print OUTFILE join " ", @haswordsP, "\n";
	close(OUTFILE);	
 	
 #print MODFILE "$teller\t$filename\t$Qpart\t$Ppart\n"; 
	
 }else{print "$teller NoQP  $line\n";} 
}
 }
close(FILE);


#check lex verifies whether the string contains am the vocab.
sub check_lex{

my $part =$_[0];
my $teller =0;
my @lexwords=();

#print "check $part\n";

my @words = split /\s+/,$part;

LOOP1: for(my $x=0;$x<=$#words;$x++)
{

  if(defined($woorden{$words[$x] }))
 {
	$teller++;
	push @lexwords,	$words[$x];
   #  print "found $words[$x]\n";
 }
 
} 


return @lexwords;
}



