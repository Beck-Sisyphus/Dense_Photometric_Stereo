% get the new vertices position in a icosahedron
%   and push the new points to the radius
% Input: subdivider ratio, from 0~1, e.x. 0.25 for 4 divider
function output = icosahedron_construction(subdivider)
    t = (1 + sqrt(5)) / 2;
    a = sqrt(t) / (5 ^ 1/4);
    b = 1 / (sqrt(t) * (5 ^ 1/4));
    c = a + 2 * b;
    d = a + b;
    
    % 12 Vertices of icosahedron
    x = [0, 0, 0, 0, b, b,-b,-b, a, a,-a,-a];
    y = [a, a,-a,-a, 0, 0, 0, 0, b,-b, b,-b];
    z = [b,-b, b,-b, a,-a, a,-a, 0, 0, 0, 0];
    
    % 20 midpoints of faces
    mx = [d, d, d, d,-d,-d,-d,-d, 0, 0, 0, 0, c, c,-c,-c, a, a,-a,-a]/3;
    my = [d,-d, d,-d, d,-d, d,-d, a, a,-a,-a, 0, 0, 0, 0, c,-c, c,-c]/3;
    mz = [d, d,-d,-d, d, d,-d,-d, c,-c, c,-c, a,-a, a,-a, 0, 0, 0, 0]/3;
    
    result = [];
    for m = 1:20
        % find the nearest neighbor, get the closest vertices index from the midpoint
        d = (x - mx(m)).^2 + (y - my(m)).^2 + (z - mz(m)).^2;
        [~, order] = sort(d);
       
        first = order(1);
        secon = order(2);
        third = order(3);
        p1 = [mx(m), my(m), mz(m)];
        p2 = [x(first), y(first), z(first)];
        p3 = [x(secon), y(secon), z(secon)];
        p4 = [x(third), y(third), z(third)];
        
        result = [result; subdivide(p1, p2, p3, subdivider)];
        result = [result; subdivide(p1, p2, p4, subdivider)];
        result = [result; subdivide(p1, p3, p4, subdivider)];
        size(result);
        
        % push the points out to the radius of the sphere for all points
        % previous points are already pushed to length 1 so they will stay
        unified = sqrt(diag((result * result')));
        result(:, 1) = result(:, 1)./unified;
        result(:, 2) = result(:, 2)./unified;
        result(:, 3) = result(:, 3)./unified;
    end

    % only take the upper half plane
    s = length(result);
    output = [];
    for i = 1:s
        if result(i, 3) >= 0
            output = [output; result(i, :)];
        end
    end
    
    size(output)
%     scatter3(output(:,1), output(:,2), output(:,3))
end

