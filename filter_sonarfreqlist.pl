
use warnings;
use utf8;

#nov 2013
# ik wil alle sonar data filteren en alleen de top X mfr woorden behouden.
# alles lower case, en alle punct verwijderen, en de stopwoorden eruit filteren.


$size = 30000;
if($size =~ /(\d+)000/){$nsize ="$1K"; }
print STDERR "size list is $size\n";

$path= "/vol/tensusers/ihendrickx/Data/LSA/R_Sonar/Sonar10K1line";

$stopfile = "$path/stopwoorden_merged"; 
$lexfile = "$path/sorted_freqlist";  #lexicon on all Sonar10K articles.
$indir= "$path/SonarNews";          #location of the sonar 10k articles
$outdir = "/$path/NewsFilt_top$nsize";    # locatie waar boel wordt weggeschreven

#als outdir er nog niet is, maak hem dan.
if (! -e $outdir){system("mkdir $outdir"); }


#lees stopwoorden en stop in hash
open(STOP,"<:encoding(UTF-8)",$stopfile);
while(<STOP>)
{
  $line =$_;
  chomp $line;
   if($line =~ /(\w.*?)\b/ )
   {
    $stopje=$1;
   # print "stop ($stopje)\n";
  $stopwords{$stopje}=1;
}
}close(STOP);

#lees het lexicon in, en bewaar het in de hash %woorden, 
#en print de lijst naar een file voor inspectie.

$keyfile = "$path/sonar_top30K_wordllist";
open(KEY, ">:encoding(UTF-8)", $keyfile);
$teller=0;

%lexhash=();
open(SFILE,"<:encoding(UTF-8)", $lexfile);
while(<SFILE>)
{
 if($teller < $size)
 {
  $line = $_;
  chomp $line;
 if($line =~ /.*\d+\s(\w\w.*)/ )
 {
   $woord = $1;
   if(defined($stopwords{$woord}))
   {
    #print " DUS stop $woord\n";
   }else{
    #print "NOT STOP ($woord)\n"; 
    $teller++;
    $lexhash{$woord}=1;
    print KEY "$woord\n";
  }
}
}
}
 close(SFILE);
close(KEY);

#foreach $key (keys %lexhash){ print "$key\n"; }


opendir (DIR, $indir) or die "Cannot open the current directory $indir";
@files=readdir (DIR);
closedir (DIR);

#for ($x=0;$x<50;$x++)
foreach $file (sort @files)
{

 #$file = $files[$x];
 #print "$x $file\n";
 $alltext ="";
 if($file =~ /lemma/){
 open(FILE, "<:encoding(UTF-8)", "$indir/$file");
 while (my $line = <FILE>) 
 {
  chomp $line;
  @tokens = split /\s+/, $line;
  foreach $tok (@tokens)
  {
   if(defined($lexhash{$tok})){$alltext .= "$tok ";   }
  }
 }
 $outfile = "$outdir/$file";

 if($alltext eq "" || $alltext !~ /\w\w/){
  print STDERR "no content for $file\n";
 }else{
 open(OUT, ">:encoding(UTF-8)", $outfile); 
 print OUT $alltext;
 close(OUT);
 close(FILE);
}

 }
}


