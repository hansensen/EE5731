function dist = getDistance(c1, c2 )

c1 = double(c1);
c2 = double(c2);

dist = (abs( c1(1) - c2(1) ) + ...
        abs( c1(2) - c2(2) ) + ...
        abs( c1(3) - c2(3) )) / 3;