package DDG::Goodie::Suicide;
# ABSTRACT: return suicide prevention hotline when the term "suicide" is used
use DDG::Goodie;

triggers start => 'suicide';

handle remainder => sub {
    return 'Need help? In the U.S., call 1-800-273-8255 (National Suicide Prevention Lifeline)';
    return;
};

zci is_cached => 1;

1;
