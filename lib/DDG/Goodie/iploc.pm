package DDG::Goodie::iploc;

use DDG::Goodie;
use WWW::Curl::Simple;

triggers start => "iploc";

zci is_cached => 1;

handle remainder => sub {
    my $curl = WWW::Curl::Simple->new();
    my $res = $curl->get("http://api.ipinfodb.com/v3/ip-city/?key=5303979b3e1c2c993d125c02517509af033390e0c73f79b13f13091b14e49c12&ip=$_&output=xml&timezone=true");
    if ($res->is_success) {
        $res = $res->decoded_content; 
        $res =~ s/\;/ /g;
        @res = split(/\s+/,$res);
        $res[6] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
        $res[5] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
        $res[7] =~ s/\b(\w)(\w*)/\U$1\L$2/g;
        return "$res[6] $res[5], $res[7] - $res[2]\n
        Map: http://www.openstreetmap.org/?lat=$res[8]&lon=$res[9]&zoom=12&layers=M";
    }
};

1;
