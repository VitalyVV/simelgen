classdef particle
    properties
        pos = [randi([36 48], [16 1]), randi([1 12], [16 2])];
        vel = randi([-12 12], [16 3]);
        mask = [];
        my_best;
        score = 0;
    end
    methods
        function f = fitness(obj)
            f = obj.pos;
            n = obj.pos;
            n(:,2:3) = [(floor(obj.pos(:,2))-4), floor((obj.pos(:,3))-7)];
            f(:,2:3) = [n(:,2)/4, n(:,3)/7];
            for i=1:16
                if abs(f(i,2)) >= 1
                    f(i,2) = -f(i,2);
                end
                if abs(f(i,3)) >= 1
                    f(i,3) = -f(i,3);
                end
            end
            y = sum(bsxfun(@eq,floor(obj.pos(:,1)),floor(obj.pos(:,1))'),1);
            tm = y >= 8;
            f(:,1) = tm;
%             tm = (floor(obj.pos(:,1)) > 48 | floor(obj.pos(:,1)) < 36 | f(:,1) == 1);
%             f(:,1) = tm;
            if f(:,1) == 0
                scr = abs(compltrans(createnmat(floor(obj.pos(:,1))', 0.5, 120)));
                if scr > 3
                    f(:,1) = 1;
                end
            end
        end   
    end
end