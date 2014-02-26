use warnings;
use utf8;


$keyfile = "/vol/tensusers/ihendrickx/Data/LSA/R_Sonar/SonarNews_20K_exp/sonar_minfr15_wordllist";

#lees het lexicon in, en bewaar het in de hash %woorden.
%woorden=();
$lexteller=0;
open(SFILE,"<:encoding(UTF-8)", $keyfile);
while(<SFILE>){

  $line =$_;
  chomp $line;
 
  if($line =~ /(.*)\b/){
    $lexteller++;
    $woorden{$lexteller}=$1;
    #print "($1)\n";
 }}
 close(SFILE);

print "Read $lexteller words\n";



$indir= "/vol/tensusers/ihendrickx/Data/LSA/R_Sonar/SonarNews_20K_exp/vocab_minfr15/wantQP/";
$outpath= "/vol/tensusers/ihendrickx/Data/LSA/R_Sonar/SonarNews_20K_exp/random_minfr15/want_rand";


opendir(my $dh, $indir) || die;
while($dir = readdir $dh) 
{
   if($dir =~ /\w\w/){	
   
     system("mkdir $outpath/$dir");
   
     @files = glob("$indir/$dir/*QP*");
     foreach $file (@files)
    {
	if(-e $file && ! -z $file){
        $count = `wc -w < $file`;# die "wc failed: $?" if $?;
        chomp($count);
	print "$count $file\n";

	if($file =~ /.*\/(.*QP.*)/ )
       {
	  $filename=$1;
	  open(OUT,">:encoding(UTF-8)","$outpath/$dir/$filename");
	  for $i (1 .. $count)
	  {
 		$num = int(rand($lexteller));
		print OUT "$woorden{$num} ";
	  }
          close(OUT);
      }
    }}
  }
}
closedir $dh;




