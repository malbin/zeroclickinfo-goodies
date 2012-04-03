package DDG::Goodie::Chars;
use DDG::Goodie;

triggers start => "chars";

zci is_cached => 1;

handle remainder => sub {
    return length $_ if $_;
    return;
};

return 1;
