% 4.2.2 helper function
% to divide the triangle evenly at each edge in an icosahedron
function result = subdivide(p1, p2, p3, q)
    result = [];
    for i = q: q: 1
        for j = 0: q/i: 1
            result = [result; j * (i * p1 + (1-i) * p2) + (1 - j) * (i * p3 + (1-i) * p2)];
        end
    end
    result = [result; p2];
end