=b
This Perl script helps you get the dp train json from a dpgen json.
$topnpy_folder: the top parent folder name with all npy files you unzip the file downloaded from https://dplibrary.deepmd.net//#/home
$dpgen_json: the dpgen json
$output_json: the output dp train json

if you meet the following error, just modify your json as the error indicates:
1.key `rcut` gets wrong value type, requires <float> but gets <int> 
---> modify integer to a floating number, in this example, modify 6 to 6.00001 

2.key `rcut_smth` gets wrong value type, requires <float> but gets <int>
---> modify integer to a floating number, in this example, modify 2 to 2.00001 

3. undefined key `load_ckpt` is not allowed in strict mode
---> delete this item in json

=cut
use warnings;
use strict;
use JSON::PP;
use Cwd;
use POSIX;
use Data::Dumper;
############# You need to provide the following parent folder name having all set.XXX folders
my $topnpy_folder = "AgAuD3";# the top parent folder name with all npy files you unzip the file downloaded from https://dplibrary.deepmd.net//#/home
my $dpgen_json = "example.json";# the dpgen json
my $output_json = "output.json";# the output dp train json
#model,loss,learning_rate,training
my $currentPath = getcwd();
my @temp = `find $currentPath/$topnpy_folder -type d -name "set.*"`;
chomp @temp;
my @allnpy; # dirs with all set.XXX folders
for (0..$#temp){
    my $temp = `dirname $temp[$_]`;
    chomp $temp;
    $allnpy[$_] = $temp;#remove the last set.XX
    #print "$allnpy[$_]\n";
}
my $json;
{
    local $/ = undef;
    open my $fh, '<', "./$dpgen_json" or die "no json file\n";
    $json = <$fh>;
    close $fh;
}
my $decoded = decode_json($json);
print $decoded->{"default_training_param"};
my $hashref = $decoded->{"default_training_param"};
#print Dumper($decoded);
my $out = encode_json($hashref);
my $decodeOut = decode_json($out);

#provide all set folders' dir
$decodeOut->{training}->{systems} = [@allnpy];
#print Dumper($out);
{
        local $| = 1;
        open my $fh, '>', "$output_json";
        print $fh JSON::PP->new->pretty->encode($decodeOut);
        close $fh;
}
