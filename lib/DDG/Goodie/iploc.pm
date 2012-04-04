package DDG::Goodie::iploc;

use DDG::Goodie;
use WWW::Curl::Simple;

triggers start => "iploc";

zci is_cached => 1;

handle remainder => sub {
    chomp($_);
    if ($_ =~ m/^(\d\d?\d?)\.(\d\d?\d?)\.(\d\d?\d?)\.(\d\d?\d?)$/ )
    {
        if ($1 <= 255 && $2 <= 255 && $3 <= 255 && $4 <= 255)
        {
            if ($_ =~ m/^192.168./ || $_ =~ m/^10./ || $_ =~ m/^172.16./ || $_ =~ m/^127./)
            {
                return "Internal IP\n";
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
                    $res[3] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
                    $res[4] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
                    $res[5] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
                    $res[6] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
                    return "$res[5], $res[4] $res[6] - $res[3]\n
                    Map: http://www.openstreetmap.org/?lat=$res[7]&lon=$res[8]&zoom=12&layers=M";
                }
            else
            {
                return "$_ is out of range!\n";
            }   
        }
    }
    else
    {
    return "$_ is not a valid IP!\n";
    }
}
};

1;
