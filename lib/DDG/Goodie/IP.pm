package DDG::Goodie::IP;

use DDG::Goodie;
use WWW::Curl::Simple;
use Net::DNS;

triggers start => "ip";

zci is_cached => 1;

handle remainder => sub {
    chomp($_); # probably not necessary
    if ($_ =~ m/^(\d\d?\d?)\.(\d\d?\d?)\.(\d\d?\d?)\.(\d\d?\d?)$/ ) # is this a valid IP format? if not, return normal results
    {
        if ($1 <= 255 && $2 <= 255 && $3 <= 255 && $4 <= 255) # is the IP in range?
        {
            if ($_ =~ m/^192.168./ || $_ =~ m/^10./ || $_ =~ m/^172.16./ || $_ =~ m/^127./) # is the IP local?
            {
                return "Error: $_ is an internal IP.\n";
            }
            else 
            {
                my $curl = WWW::Curl::Simple->new();
                my $res = $curl->get("http://api.ipinfodb.com/v3/ip-city/?key=5303979b3e1c2c993d125c02517509af033390e0c73f79b13f13091b14e49c12&ip=$_&output=xml&timezone=true");
                if ($res->is_success) 
                {
                    $res = $res->decoded_content; 
                    $res =~ s/\;/|/g;
                    @res = split(/\|+/,$res);
                    $res[3] =~ s/\b(\w)(\w*)/\U$1\L$2/g; # Format output from curl
                    $res[4] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
                    $res[5] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
                    $res[6] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
                    my $hostname = gethostbyaddr(pack('C4',split('\.',$_)),2);
                    return "$_ is $hostname\n
                    $res[5], $res[4] $res[6] - $res[3] (<a href=\"http://maps.stamen.com/toner/#14/$res[7]/$res[8]\">map</a>)";
                }
            else
            {
                return "Error: $_ is out of range.\n";
            }   
        }
    }}
    else
    {
    return;
    }
};

1;
