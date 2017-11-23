classdef melody_bar
     properties
        pos = [];
        vel = randi([-12 12], [16 2]);
        my_best;
        score = inf;
     end
     methods     
         function f = fitness(obj)
            temp = [];
            j = 1;
            while j <= 16
               temp = [temp; obj.pos(j,1); obj.pos(j,2)]; 
               j = j+1;
            end
            f = (gradus(createnmat(floor(temp)',0.25, 120)));
         end
     end
     
end