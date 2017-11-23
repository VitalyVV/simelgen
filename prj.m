%PSO
pop = 30; % create population of bars
for i = 1:pop
    particles(i) = particle;
    particles(i).my_best = particles(i).pos;
end

global_best = [];
glob_score = inf;
velic = [];
k = 1;
prev_vel = [];

n = 1;
w = 1;
dump = 0.999;
%run PSO loop
while (sum(sum(particles(k).mask)) ~= 0) || (glob_score > 4)
    %update local best positions.
    for i = 1:pop
        f = particles(i).score;
        particles(i).mask = particles(i).fitness();
        particles(i).score = sum(sum(abs(particles(i).mask))) +...
            abs(compltrans(createnmat(floor(particles(i).pos(:,1))', 0.5, 120)));
        if particles(i).score <= f || n == 1
             particles(i).my_best = particles(i).pos;
        end
        if particles(i).score < glob_score
            glob_score = particles(i).score;
            global_best = particles(i).pos;
            k = i;
        end
    end
    clear('f');
    
    %update  
    for i = 1:pop
       particles(i).vel(:,1) =(w*particles(i).vel(:,1) ...
                            +2*rand().*(particles(i).my_best(:,1) - particles(i).pos(:,1))...
                            +2*rand().*(global_best(:,1) - particles(i).pos(:,1)));
       particles(i).vel(:,2:3) = [4*particles(i).mask(:,2), 7*particles(i).mask(:,3)];
   
       particles(i).pos(:,1) = mod(particles(i).pos(:,1)+(particles(i).mask(:,1) .* particles(i).vel(:,1)), 12) + 48;
       particles(i).pos(:,2:3) = (particles(i).pos(:,2:3))+(particles(i).vel(:,2:3));
    end
    n = n + 1;
    glob_score
end

for i = 1:16
    global_best(i,:) = [global_best(i,1), (global_best(i,1)+global_best(i,2)), (global_best(i,1)+global_best(i,3))];
end
 
offset = 0;
chords = [];
for i = 1:16
    chord = createnmat(floor(global_best(i, :)), 0.5, 120);
    chord = setvalues(chord, 'onset', offset, 'sec');
    offset = offset + 0.5;
    chords = [chords; chord];
end

%Clearing variables
clear('offset');
clear('ans');
clear('chord');
clear('i');
clear('j');
clear('prk');
