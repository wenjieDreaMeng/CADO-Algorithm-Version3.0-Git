function Test(  )

%   π¶ƒ‹£∫≤‚ ‘≥Ã–Ú
clc;
Total = 100;

xa = 0:1:Total;
ya = xa;
[x,y] = meshgrid(xa,ya);
z = (x.*y)./(x+y+x.*y);

max(max(z))

mesh(x,y,z);

end

